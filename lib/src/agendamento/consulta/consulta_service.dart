import 'dart:async';
import 'consulta.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/angular_components.dart';
import 'appointment_scheduling_dao.dart';

import '../../agendamento/shift/shift_service.dart';
import '../../agendamento/agreement/agreement_service.dart';
import '../../agendamento/dentist/dentist_service.dart';

class ConsultaService {
  static Consulta _consulta;
  static List<Consulta> _list;
  static Map _appointmentSchedulingByDate = new Map();
  static Map _appointmentSchedulingByDateWithFilter = new Map();

  Consulta get consulta => _consulta;
  set consulta(Consulta consulta) => _consulta = consulta;

  void clearAllAppointmentSchedulingByDate() {
    _appointmentSchedulingByDate.clear();
    _appointmentSchedulingByDateWithFilter.clear();
  }

  Future<List<Consulta>> getAllAppointmentSchedulingByDate(Date date) async {
    if ((_appointmentSchedulingByDate != null) && (_appointmentSchedulingByDate.length != 0)) {
      return _list;
    }

    await (_appointmentSchedulingByDate[date.toString()] =
        await new AppointmentSchedulingDAO().getAllAppointmentSchedulingFilter({
      'dateAppointmentScheduling':
          new DateFormat('yyyy-MM-dd').format(date.asUtcTime())
    }));

    return _list;
  }

  Future<List<Map>> getAllAppointmentSchedulingByDateMap(Date date) async {
    await getAllAppointmentSchedulingByDate(date);

    return _appointmentSchedulingByDate[date.toString()];
  }

  Future<Map> getAllAppointmentSchedulingListMap(Date date) async {
    return _appointmentSchedulingByDate;
  }

  Consulta getAppointmentSchedulingByIdFromList(String id) {
    if ((_appointmentSchedulingByDate != null) && (_appointmentSchedulingByDate.length != 0)){
      for (var i = 0; i < _list.length; i++) {
        if (_list[i].id == id) {
          _consulta = _list[i];
          return _consulta;
        }
      }
    }

    return null;
  }

  List<Map> getAppointmentSchedulingWithFilterFromList(
      String date, Map filter) {
    List<Map> _listDocumentSnapshot = new List<Map>();

    List<Map> _listDocumentSnapshotTemp = new List<Map>();

    void ListsApplyFilter() {
      if (_listDocumentSnapshotTemp.length > 0) {
        _listDocumentSnapshotTemp.forEach((doc) {
          _listDocumentSnapshot.add(new Map.from(doc));
        });

        _listDocumentSnapshotTemp.clear();
      }
    }

    _listDocumentSnapshot = _appointmentSchedulingByDate[date.toString()];

    _listDocumentSnapshotTemp.clear();

    _listDocumentSnapshot.forEach((doc) {
      if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
        if (filter["dentistId"] == doc["dentistId"]) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      } else {
        _listDocumentSnapshotTemp.add(new Map.from(doc));
      }
    });

    if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    if ((filter["shiftId"] != null) && (filter["shiftId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if ((doc["shiftId"] == '') || (doc["shiftId"] == null)) {
          if ((doc["hourId"] == 'JVWNJdwwqjFXCbmuGWf0') ||
              (doc["hourId"] == 'Q14M2Diimon1ksVLO3TO') ||
              (doc["hourId"] == 'hql4fUJfU8vhoxaF7IkB') ||
              (doc["hourId"] == 'mUFFpnp6CP53gnEuS9DU')) {
            doc["shiftId"] = '1a5XNjDT8qfLQ53KSSxh';
          } else {
            doc["shiftId"] = 'fBXihJRGPTPepfkfbxSs';
          }
        }

        if (filter["shiftId"] == doc["shiftId"]) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["shiftId"] != null) && (filter["shiftId"] != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    if ((filter["patient"] != null) && (filter["patient"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["patient"].toString().indexOf(filter["patient"]) > -1) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["patient"] != null) && (filter["patient"] != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    _appointmentSchedulingByDateWithFilter[date] = _listDocumentSnapshot;

    return _appointmentSchedulingByDateWithFilter[date];
  }

  Future<Consulta> getAppointmentSchedulingById(String id) async {
    if ((_appointmentSchedulingByDate != null) && (_appointmentSchedulingByDate.length != 0)) {
      for (var i = 0; i < _list.length; i++) {
        if (_list[i].id == id) {
          _consulta = _list[i];
          return _consulta;
        }
      }
    }

    Map doc = (await new AppointmentSchedulingDAO()
            .getAllAppointmentSchedulingFilter({'id': id}))
        .first;

    return new Consulta(
      doc["documentPath"],
      doc["dateAppointmentScheduling"],
      doc["hourId"],
      doc["minuteId"],
      doc["shiftId"],
      doc["dentistId"],
      doc["patient"],
      doc["email"],
      doc["tel"],
      doc["userId"],
      await new ShiftService().getShiftById(doc["shiftId"], doc["hourId"]),
      await new DentistService().getDentistById(doc["dentistId"]),
      await new AgreementService().getAgreementById(doc["agreementId"]),
    );
  }
}
