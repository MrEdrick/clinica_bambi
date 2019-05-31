import 'dart:async';
import 'auto_appointment_scheduling.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/angular_components.dart';
import 'auto_appointment_scheduling_dao.dart';

import '../../appointment/shift/shift_service.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/procedure/procedure_service.dart';

class AutoAppointmentSchedulingService {
  static AutoAppointmentScheduling _autoAppointmentScheduling;
  static Map _autoAppointmentSchedulingById = new Map();
  static Map _autoAppointmentSchedulingByDate = new Map();
  static Map _autoAppointmentSchedulingByDateWithFilter = new Map();

  AutoAppointmentScheduling get autoAppointmentScheduling =>
      _autoAppointmentScheduling;
  set autoAppointmentScheduling(
          AutoAppointmentScheduling autoAppointmentScheduling) =>
      _autoAppointmentScheduling = autoAppointmentScheduling;

  void clearAllAutoAppointmentSchedulingByDate() {
    _autoAppointmentSchedulingByDate.clear();
    _autoAppointmentSchedulingByDateWithFilter.clear();
    _autoAppointmentSchedulingById.clear();
  }

  Future<Map> getAllAutoAppointmentSchedulingByDate(Date date) async {
    if ((_autoAppointmentSchedulingByDate != null) &&
        (_autoAppointmentSchedulingByDate.length != 0)) {
      return _autoAppointmentSchedulingByDate;
    }

    await (_autoAppointmentSchedulingByDate[date.toString()] =
        await new AutoAppointmentSchedulingDAO()
            .getAllAutoAppointmentSchedulingFilter({
      'dateAppointmentScheduling':
          new DateFormat('yyyy-MM-dd').format(date.asUtcTime())
    }));

    _autoAppointmentSchedulingByDate[date.toString()]
        .forEach((autoAppointmentScheduling) {
      _autoAppointmentSchedulingById[
              autoAppointmentScheduling["documentPath"]] =
          autoAppointmentScheduling;
    });

    return _autoAppointmentSchedulingByDate;
  }

  Future<List<Map>> getAllAutoAppointmentSchedulingByDateMap(Date date) async {
    await getAllAutoAppointmentSchedulingByDate(date);

    return _autoAppointmentSchedulingByDate[date.toString()];
  }

  Future<Map> getAllAutoAppointmentSchedulingListMap(Date date) async {
    return _autoAppointmentSchedulingByDate;
  }

  Map getAutoAppointmentSchedulingByIdFromList(String id) {
    return _autoAppointmentSchedulingById[id];
  }

  Map getAutoAppointmentScheduling() {
    return _autoAppointmentSchedulingById;
  }

  List<Map> getAutoAppointmentSchedulingWithFilterFromList(
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

    _listDocumentSnapshot = _autoAppointmentSchedulingByDate[date.toString()];

    _listDocumentSnapshotTemp.clear();

    _listDocumentSnapshot.forEach((doc) {
      if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
        if (filter["dentistId"] == doc["dentistId"]) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      }
    });

    if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

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
      ListsApplyFilter();
    }

    if ((filter["patient"] != null) && (filter["patient"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["patient"].toString().indexOf(filter["patient"]) > -1) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["patient"] != null) && (filter["patient"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    _autoAppointmentSchedulingByDateWithFilter[date] = _listDocumentSnapshot;

    return _autoAppointmentSchedulingByDateWithFilter[date];
  }

  List<Map> getAutoAppointmentSchedulingFromListWithFilterByDate(String date) {
    return _autoAppointmentSchedulingByDateWithFilter[date];
  }

  Future<AutoAppointmentScheduling> getAutoAppointmentSchedulingById(
      String id) async {
    Map doc;

    doc = _autoAppointmentSchedulingById[id];

    if (doc == null) {
      doc = (await new AutoAppointmentSchedulingDAO()
              .getAllAutoAppointmentSchedulingFilter({'id': id}))
          .first;
    }

    return await turnMapInAutoAppointmentScheduling(doc);
  }

  Future<AutoAppointmentScheduling> turnMapInAutoAppointmentScheduling(
      Map map) async {
    return await (new AutoAppointmentScheduling(
        map["documentPath"],
        map["dateAppointmentScheduling"],
        map["shiftId"],
        map["dentistId"],
        map["patient"],
        map["email"],
        map["tel"],
        map["patientAccountId"],
        await new ShiftService().getShiftById(map["shiftId"]),
        await new DentistService().getDentistById(map["dentistId"]),
        await new AgreementService().getAgreementById(map["agreementId"]),
        await new ProcedureService().getProcedureById(map["procedureId"])));
  }
}
