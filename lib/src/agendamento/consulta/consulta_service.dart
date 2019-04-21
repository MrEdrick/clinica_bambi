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
  static Map _appointmentSchedulingById = new Map();
  static Map _appointmentSchedulingByDate = new Map();
  static Map _appointmentSchedulingByDateWithFilter = new Map();

  Consulta get consulta => _consulta;
  set consulta(Consulta consulta) => _consulta = consulta;

  void clearAllAppointmentSchedulingByDate() {
    _appointmentSchedulingByDate.clear();
    _appointmentSchedulingByDateWithFilter.clear();
    _appointmentSchedulingById.clear();
  }

  Future<Map> getAllAppointmentSchedulingByDate(Date date) async {
    if ((_appointmentSchedulingByDate != null) &&
        (_appointmentSchedulingByDate.length != 0)) {
      return _appointmentSchedulingByDate;
    }

    await (_appointmentSchedulingByDate[date.toString()] =
        await new AppointmentSchedulingDAO().getAllAppointmentSchedulingFilter({
      'dateAppointmentScheduling':
          new DateFormat('yyyy-MM-dd').format(date.asUtcTime())
    }));

    _appointmentSchedulingByDate[date.toString()]
        .forEach((appointmentScheduling) {
      _appointmentSchedulingById[appointmentScheduling["documentPath"]] =
          appointmentScheduling;
    });

    return _appointmentSchedulingByDate;
  }

  Future<List<Map>> getAllAppointmentSchedulingByDateMap(Date date) async {
    await getAllAppointmentSchedulingByDate(date);

    return _appointmentSchedulingByDate[date.toString()];
  }

  Future<Map> getAllAppointmentSchedulingListMap(Date date) async {
    return _appointmentSchedulingByDate;
  }

  Map getAppointmentSchedulingByIdFromList(String id) {
    return _appointmentSchedulingById[id];
  }

  int getAppointmentSchedulingLentgh(String id) {
    return _appointmentSchedulingById.length;
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

  List<Map> getAppointmentSchedulingFromListWithFilterByDate(String date) {
    return _appointmentSchedulingByDateWithFilter[date];
  }

  Future<Consulta> getAppointmentSchedulingById(String id) async {
    Map doc;

    doc = _appointmentSchedulingById[id];

    if (doc == null) {
      doc = (await new AppointmentSchedulingDAO()
              .getAllAppointmentSchedulingFilter({'id': id}))
          .first;
    }

    return await turnMapInConsulta(doc);
  }

  Future<Consulta> turnMapInConsulta(Map map) async {
    return await (new Consulta(
        map["documentPath"],
        map["dateAppointmentScheduling"],
        map["hourId"],
        map["minuteId"],
        map["shiftId"],
        map["dentistId"],
        map["patient"],
        map["email"],
        map["tel"],
        map["userId"],
        await new ShiftService().getShiftById(map["shiftId"], map["hourId"]),
        await new DentistService().getDentistById(map["dentistId"]),
        await new AgreementService().getAgreementById(map["agreementId"])));
  }
}
