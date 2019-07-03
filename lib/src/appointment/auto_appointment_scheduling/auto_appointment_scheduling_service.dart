import 'dart:async';
import '../../appointment/appointment_scheduling/appointment_scheduling.dart';
import '../../appointment/dentist/dentist.dart';
import '../../appointment/procedure/procedure.dart';
import '../../appointment/shift/shift.dart';
import '../../appointment/agreement/agreement.dart';

import 'auto_appointment_scheduling.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/angular_components.dart';
import 'auto_appointment_scheduling_dao.dart';

import '../../appointment/shift/shift_service.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/procedure/procedure_service.dart';
import '../../appointment/appointment_scheduling/appointment_scheduling_service.dart';

class AutoAppointmentSchedulingService {
  static AutoAppointmentScheduling _autoAppointmentScheduling;
  static Map _autoAppointmentSchedulingById = new Map();
  static Map _autoAppointmentSchedulingByPatientAccountId = new Map();
  static Map _autoAppointmentSchedulingByPatientAccountIdDate = new Map();
  static Map _autoAppointmentSchedulingByPatientAccountIdDateWithFilter =
      new Map();

  final AppointmentSchedulingService appointmentSchedulingService =
      new AppointmentSchedulingService();

  AutoAppointmentScheduling get autoAppointmentScheduling =>
      _autoAppointmentScheduling;
  set autoAppointmentScheduling(
          AutoAppointmentScheduling autoAppointmentScheduling) =>
      _autoAppointmentScheduling = autoAppointmentScheduling;

  void clearAllAutoAppointmentScheduling() {
    _autoAppointmentSchedulingByPatientAccountId.clear();
    _autoAppointmentSchedulingByPatientAccountIdDate.clear();
    _autoAppointmentSchedulingByPatientAccountIdDateWithFilter.clear();
    _autoAppointmentSchedulingById.clear();
  }

  Future<Map> getAllAutoAppointmentSchedulingByPatientAccountId(
      String patientAccountId) async {
    if ((_autoAppointmentSchedulingByPatientAccountId != null) &&
        (_autoAppointmentSchedulingByPatientAccountId.length != 0)) {
      return _autoAppointmentSchedulingByPatientAccountId;
    }

    clearAllAutoAppointmentScheduling();

    await (_autoAppointmentSchedulingByPatientAccountId[patientAccountId] =
        await new AutoAppointmentSchedulingDAO()
            .getAllAutoAppointmentSchedulingFilter(
                {'patientAccountId': patientAccountId}));

    _autoAppointmentSchedulingByPatientAccountId[patientAccountId]
        .forEach((autoAppointmentScheduling) {
      _autoAppointmentSchedulingById[
              autoAppointmentScheduling["documentPath"]] =
          autoAppointmentScheduling;
    });

    return _autoAppointmentSchedulingByPatientAccountId;
  }

  Future<Map> getAllAutoAppointmentSchedulingByPatientAccountIdDate(
      String patientAccountId) async {
    if ((_autoAppointmentSchedulingByPatientAccountIdDate != null) &&
        (_autoAppointmentSchedulingByPatientAccountIdDate.length != 0)) {
      return _autoAppointmentSchedulingByPatientAccountIdDate;
    }

    await getAllAutoAppointmentSchedulingByPatientAccountId(patientAccountId);

    _autoAppointmentSchedulingByPatientAccountId[patientAccountId]
        .forEach((autoAppointmentScheduling) {
      _autoAppointmentSchedulingByPatientAccountIdDate[
              patientAccountId + autoAppointmentScheduling.dateAppointmentScheduling].add(autoAppointmentScheduling);
    });

    return _autoAppointmentSchedulingByPatientAccountIdDate;
  }

  Future<List<Map>> getAllAutoAppointmentSchedulingByPatientAccountIdDateMap(
      String patientAccountId, Date date) async {
    await getAllAutoAppointmentSchedulingByPatientAccountIdDate(
        patientAccountId);

    return _autoAppointmentSchedulingByPatientAccountIdDate[
        patientAccountId + date.toString()];
  }

  Future<Map> getAllAutoAppointmentSchedulingListMap() async {
    return _autoAppointmentSchedulingByPatientAccountIdDate;
  }

  Map getAutoAppointmentSchedulingByIdFromList(String id) {
    return _autoAppointmentSchedulingById[id];
  }

  Map getAutoAppointmentScheduling() {
    return _autoAppointmentSchedulingById;
  }

  List<Map> getAutoAppointmentSchedulingWithFilterFromList(
      String patientAccountId, Date date, Map filter) {
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

    _listDocumentSnapshot.clear();
    _autoAppointmentSchedulingByPatientAccountIdDate[
            patientAccountId + date.toString()]
        .forEach((autoAppointmentSchedulingByPatientAccountIdDate) {
      _listDocumentSnapshot
          .add(autoAppointmentSchedulingByPatientAccountIdDate);
    });

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

    _autoAppointmentSchedulingByPatientAccountIdDateWithFilter[
        patientAccountId + date.toString()] = _listDocumentSnapshot;

    return _autoAppointmentSchedulingByPatientAccountIdDateWithFilter[date];
  }

  List<Map>
      getAutoAppointmentSchedulingFromListWithFilterByPatientAccountIdDate(
          String patientAccountId, Date date) {
    return _autoAppointmentSchedulingByPatientAccountIdDateWithFilter[
        patientAccountId + date.toString()];
  }

  Future<AutoAppointmentScheduling> getAutoAppointmentSchedulingById(
      String id) async {
    Map doc;

    if (id.isEmpty) {
      return returnEmptyAutoAppointmentScheduling();
    }

    if (_autoAppointmentSchedulingById.isNotEmpty) {
      doc = _autoAppointmentSchedulingById[id];
    }

    if (doc == null) {
      doc = (await new AutoAppointmentSchedulingDAO()
              .getAllAutoAppointmentSchedulingFilter({'id': id}))
          .first;
    }

    return await turnMapInAutoAppointmentScheduling(doc);
  }

  AutoAppointmentScheduling returnEmptyAutoAppointmentScheduling() {
    return new AutoAppointmentScheduling(
        '',
        Date.today().toString(),
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        new Shift('', '', false),
        new Dentist('', '', false),
        new Agreement('', '', false),
        new Procedure('', '', false));
  }

  Future<AutoAppointmentScheduling> turnMapInAutoAppointmentScheduling(
      Map map) async {
    return await (new AutoAppointmentScheduling(
        map["documentPath"],
        map["dateAppointmentScheduling"],
        map["shiftId"],
        map["dentistId"],
        map["agreemetId"],
        map["procedureId"],
        map["patient"],
        map["email"],
        map["tel"],
        map["patientAccountId"],
        await new ShiftService().getShiftById(map["shiftId"]),
        await new DentistService().getDentistById(map["dentistId"]),
        await new AgreementService().getAgreementById(map["agreementId"]),
        await new ProcedureService().getProcedureById(map["procedureId"])));
  }

  Future<bool> save() async {
    bool saved = true;
    Map<bool, String> result = new Map<bool, String>();

    if (_autoAppointmentScheduling == null) {
      return saved;
    }

    Map<String, dynamic> datas = {
      "dateAppointmentScheduling":
          _autoAppointmentScheduling.dateAppointmentScheduling,
      "agreementId": _autoAppointmentScheduling.agreementId,
      "dentistId": _autoAppointmentScheduling.dentistId,
      "shiftId": _autoAppointmentScheduling.shiftId,
      "procedureId": _autoAppointmentScheduling.procedureId,
      "patient": _autoAppointmentScheduling.patient,
      "email": _autoAppointmentScheduling.email,
      "tel": _autoAppointmentScheduling.telephone,
      "patientAccountId": _autoAppointmentScheduling.patientAccountId
    };

    if (_autoAppointmentScheduling.id != "") {
      result[await new AutoAppointmentSchedulingDAO()
              .update(_autoAppointmentScheduling.id, datas) ==
          ""] = _autoAppointmentScheduling.id;
    } else {
      result = await new AutoAppointmentSchedulingDAO().save(datas);
    }

    saved = result.keys.first;

    if (saved) {
      if (_autoAppointmentScheduling.id != "") {
        appointmentSchedulingService.appointmentScheduling =
            await (appointmentSchedulingService
                .getAppointmentSchedulingByFilterFromDB(
                    {'autoAppointmentSchedulingId': result.values.first}));
      } else {
        appointmentSchedulingService.appointmentScheduling =
            appointmentSchedulingService.returnEmptyAppointmentShceduling();
        appointmentSchedulingService.appointmentScheduling
            .autoAppointmentSchedulingId = result.values.first;
      }

      appointmentSchedulingService
              .appointmentScheduling.dateAppointmentScheduling =
          _autoAppointmentScheduling.dateAppointmentScheduling;
      appointmentSchedulingService.appointmentScheduling.shiftId =
          _autoAppointmentScheduling.shiftId;
      appointmentSchedulingService.appointmentScheduling.dentistId =
          _autoAppointmentScheduling.dentistId;
      appointmentSchedulingService.appointmentScheduling.agreementId =
          _autoAppointmentScheduling.agreementId;
      appointmentSchedulingService.appointmentScheduling.patient =
          _autoAppointmentScheduling.patient;
      appointmentSchedulingService.appointmentScheduling.email =
          _autoAppointmentScheduling.email;
      appointmentSchedulingService.appointmentScheduling.telephone =
          _autoAppointmentScheduling.telephone;

      saved = await appointmentSchedulingService.save();
    }

    return saved;
  }
}
