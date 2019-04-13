import 'dart:async';
import 'consulta.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/angular_components.dart';
import 'appointment_scheduling_dao.dart';

class ConsultaService {
  static Consulta _consulta;
  static List<Consulta> _list;
  static List<Map> _listMap;

  Consulta get consulta => _consulta;
  set consulta(Consulta consulta) => _consulta = consulta;

  Future<List<Consulta>> getAllAppointmentSchedulingByDate(Date date) async {
    if (_list != null) {
      return _list;
    }

    List<DocumentSnapshot> _listDocumentSnapshot = await new AppointmentSchedulingDAO().getAllAppointmentSchedulingFilter({
      'dateAppointmentScheduling':
          new DateFormat('yyyy-MM-dd').format(date.asUtcTime())
    });

    _listDocumentSnapshot.forEach((doc) {
            Map map = new Map.from(doc.data());
            map['documentPath'] = doc.id;
            _listMap.add(map);
            _list.add(new Consulta(
                            doc.id,
                            doc.data()["dateAppointmentScheduling"],
                            doc.data()["hourId"],
                            doc.data()["minuteId"],
                            doc.data()["shiftId"],
                            doc.data()["dentistId"],
                            doc.data()["patient"],
                            doc.data()["email"],
                            doc.data()["tel"],
                            doc.data()["userId"],
                            await new ShiftService().getShiftById(doc.data()["shiftId"], doc.data()["hourId"]),
                            await new DentistService().getDentistById(doc.data()["dentistId"]),
                            await new AgreementService().getAgreementById(doc.data()["agreementId"]),
                          )
                      )
          });

    return _list;
  }

  Future<List<Map>> getAllAppointmentSchedulingByDateMap(Date date) async {
    await getAllAppointmentSchedulingByDate(date);

    return _listMap;
  }

  Future<Consulta> getDentistById(String id) async {
    if (_list != null) {
      for (var i = 0; i < _list.length; i++) {
        if (_list[i].id == id) {
          _consulta = _list[i];
          return _consulta;
        }
      }
    }

    _consulta = (await new AppointmentSchedulingDAO()
        .getAllAppointmentSchedulingFilter({'id': id})).first;

    return _consulta;
  }
}
