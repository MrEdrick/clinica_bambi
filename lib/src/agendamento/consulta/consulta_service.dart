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
  static List<Map> _listMap;

  Consulta get consulta => _consulta;
  set consulta(Consulta consulta) => _consulta = consulta;

  Future<List<Consulta>> getAllAppointmentSchedulingByDate(Date date) async {
    if (_list != null) {
      return _list;
    }

    _listMap =
        await new AppointmentSchedulingDAO().getAllAppointmentSchedulingFilter({
      'dateAppointmentScheduling':
          new DateFormat('yyyy-MM-dd').format(date.asUtcTime())
    });

    await _listMap.forEach((doc) async {
      _list.add(new Consulta(
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
      ));
    });
    return _list;
  }

  Future<List<Map>> getAllAppointmentSchedulingByDateMap(Date date) async {
    await getAllAppointmentSchedulingByDate(date);

    return _listMap;
  }

  Consulta getDentistByIdFromList(String id) {
    if (_list != null) {
      for (var i = 0; i < _list.length; i++) {
        if (_list[i].id == id) {
          _consulta = _list[i];
          return _consulta;
        }
      }
    }
    
    return null;
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
