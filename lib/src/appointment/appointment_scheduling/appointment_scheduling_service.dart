import 'dart:async';

import 'package:intl/intl.dart';
import 'package:angular_components/angular_components.dart';
import 'appointment_scheduling.dart';
import 'appointment_scheduling_dao.dart';
import 'appointment_scheduling_dao.dart';

import '../../appointment/shift/shift_service.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/procedure/procedure_service.dart';
import '../../appointment/configuration/auto_appointment_scheduling_configuration/auto_appointment_scheduling_configuration_service.dart';
import '../../appointment/generic/generic_service.dart';

class AppointmentSchedulingService {
  static AppointmentScheduling _appointmentScheduling;
  static Map _appointmentSchedulingById = new Map();
  static Map _appointmentSchedulingByPatientAccountId = new Map();
  static Map _appointmentSchedulingByPatientAccountIdDate = new Map();
  static Map _appointmentSchedulingByPatientAccountIdDateWithFilter = new Map();

  final DentistService dentistService = new DentistService();
  final ProcedureService procedureService = new ProcedureService();
  final AgreementService agreementService = new AgreementService();
  final ShiftService shiftService = new ShiftService();
  final AutoAppointmentSchedulingConfigurationService
      appointmentSchedulingConfigurationService =
      new AutoAppointmentSchedulingConfigurationService();

  AppointmentScheduling get appointmentScheduling => _appointmentScheduling;
  set appointmentScheduling(AppointmentScheduling appointmentScheduling) =>
      _appointmentScheduling = appointmentScheduling;

  void clearAllappointmentScheduling() {
    _appointmentSchedulingByPatientAccountId.clear();
    _appointmentSchedulingByPatientAccountIdDate.clear();
    _appointmentSchedulingByPatientAccountIdDateWithFilter.clear();
    _appointmentSchedulingById.clear();
  }

  Map get appointmentSchedulingByPatientAccountId =>
      _appointmentSchedulingByPatientAccountId;

  Future<Map> getAllAppointmentSchedulingByPatientAccountId(
      String patientAccountId) async {
    if ((_appointmentSchedulingByPatientAccountId != null) &&
        (_appointmentSchedulingByPatientAccountId.length != 0)) {
      return _appointmentSchedulingByPatientAccountId;
    }

    clearAllappointmentScheduling();

    await (_appointmentSchedulingByPatientAccountId[patientAccountId] =
        await new AppointmentSchedulingDAO()
            .getAllAppointmentSchedulingFilter({}));

    _appointmentSchedulingByPatientAccountId[patientAccountId]
        .forEach((appointmentScheduling) {
      _appointmentSchedulingById[appointmentScheduling["documentPath"]] =
          appointmentScheduling;
    });

    return _appointmentSchedulingByPatientAccountId;
  }

  Future<List<Map>> getAllAppointmentSchedulingByDateByHoraryByDentistId(
      String date, String horary, String dentistId) async {
    return await new AppointmentSchedulingDAO()
        .getAllAppointmentSchedulingFilter({
      'dateAppointmentScheduling': date,
      'dentistId': dentistId,
      'horary': horary
    });
  }

  Future<Map> getAllAppointmentSchedulingByPatientAccountIdDate(
      String patientAccountId) async {
    if ((_appointmentSchedulingByPatientAccountIdDate != null) &&
        (_appointmentSchedulingByPatientAccountIdDate.length != 0)) {
      return _appointmentSchedulingByPatientAccountIdDate;
    }
    await getAllAppointmentSchedulingByPatientAccountId(patientAccountId);
    _appointmentSchedulingByPatientAccountId[patientAccountId]
        .forEach((appointmentScheduling) {
      if (_appointmentSchedulingByPatientAccountIdDate[patientAccountId +
              appointmentScheduling["dateAppointmentScheduling"]] ==
          null) {
        _appointmentSchedulingByPatientAccountIdDate[patientAccountId +
                appointmentScheduling["dateAppointmentScheduling"]] =
            new List<Map>();
      }
      _appointmentSchedulingByPatientAccountIdDate[patientAccountId +
              appointmentScheduling["dateAppointmentScheduling"]]
          .add(appointmentScheduling);
    });

    return _appointmentSchedulingByPatientAccountIdDate;
  }

  Future<List<Map>> getAllAppointmentSchedulingByPatientAccountIdDateMap(
      String patientAccountId, Date date) async {
    await getAllAppointmentSchedulingByPatientAccountIdDate(patientAccountId);

    return _appointmentSchedulingByPatientAccountIdDate[
        patientAccountId + date.toString()];
  }

  Future<Map> getAllAppointmentSchedulingListMap() async {
    return _appointmentSchedulingByPatientAccountIdDate;
  }

  Map getAppointmentSchedulingByIdFromList(String id) {
    return _appointmentSchedulingById[id];
  }

  Map getAppointmentScheduling() {
    return _appointmentSchedulingById;
  }

  List<Map> getAppointmentSchedulingWithFilterFromList(
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

    _appointmentSchedulingByPatientAccountIdDate[patientAccountId +
            (new DateFormat('yyyy-MM-dd').format(date.asUtcTime()))]
        ?.forEach((appointmentSchedulingByPatientAccountIdDate) {
      _listDocumentSnapshot.add(appointmentSchedulingByPatientAccountIdDate);
    });

    _listDocumentSnapshotTemp.clear();

    if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (filter["dentistId"] == doc["dentistId"]) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }
    ;

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

    if ((filter["horary"] != null) && (filter["horary"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (filter["horary"] == doc["horary"]) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }
    ;

    if ((filter["horary"] != null) && (filter["horary"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    _appointmentSchedulingByPatientAccountIdDateWithFilter[
        patientAccountId + date.toString()] = _listDocumentSnapshot;

    return _appointmentSchedulingByPatientAccountIdDateWithFilter[date];
  }

  List<Map> getAppointmentSchedulingFromListWithFilterByPatientAccountIdDate(
      String patientAccountId, Date date) {
    return _appointmentSchedulingByPatientAccountIdDateWithFilter[
        patientAccountId + date.toString()];
  }

  Future<AppointmentScheduling> getAppointmentSchedulingById(String id) async {
    Map doc;

    if (id.isEmpty) {
      return returnEmptyAppointmentScheduling();
    }

    if (_appointmentSchedulingById.isNotEmpty) {
      doc = _appointmentSchedulingById[id];
    }

    if (doc == null) {
      doc = (await new AppointmentSchedulingDAO()
              .getAllAppointmentSchedulingFilter({'id': id}))
          .first;
    }

    return await turnMapInAppointmentScheduling(doc);
  }

  Future<AppointmentScheduling>
      getAppointmentSchedulingByAutoAppointmentSchedulingId(
          String autoAppointmentSchedulingId) async {
    Map doc;

    if (autoAppointmentSchedulingId.isEmpty) {
      return returnEmptyAppointmentScheduling();
    }

    if (_appointmentSchedulingById.isNotEmpty) {
      doc = _appointmentSchedulingById[autoAppointmentSchedulingId];
    }

    if (doc == null) {
      doc = (await new AppointmentSchedulingDAO()
              .getAllAppointmentSchedulingFilter(
                  {'autoAppointmentSchedulingId': autoAppointmentSchedulingId}))
          .first;
    }

    return await turnMapInAppointmentScheduling(doc);
  }

  Future<AppointmentScheduling> getAppointmentSchedulingByFilter(
      Map filter) async {
    Map doc;

    if (filter.isEmpty) {
      return returnEmptyAppointmentScheduling();
    }

    if (doc == null) {
      doc = (await new AppointmentSchedulingDAO()
              .getAllAppointmentSchedulingFilter(filter))
          .first;
    }

    return await turnMapInAppointmentScheduling(doc);
  }

  AppointmentScheduling returnEmptyAppointmentScheduling() {
    return new AppointmentScheduling(
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
        '',
        shiftService.returnEmptyShift(),
        dentistService.returnEmptyDentist(),
        agreementService.returnEmptyAgreement(),
        procedureService.returnEmptyProcedure());
  }

  Future<AppointmentScheduling> turnMapInAppointmentScheduling(Map map) async {
    return await (new AppointmentScheduling(
        map["documentPath"],
        map["dateAppointmentScheduling"],
        new GenericService().returnStringEmptyIfNull(map["shiftId"]),
        new GenericService().returnStringEmptyIfNull(map["dentistId"]),
        new GenericService().returnStringEmptyIfNull(map["agreementId"]),
        new GenericService().returnStringEmptyIfNull(map["procedureId"]),
        new GenericService()
            .returnStringEmptyIfNull(map["autoAppointmentSchedulingId"]),
        map["patient"],
        map["email"],
        map["tel"],
        map["horary"],
        await new ShiftService().getShiftById(
            new GenericService().returnStringEmptyIfNull(map["shiftId"])),
        await new DentistService().getDentistById(
            new GenericService().returnStringEmptyIfNull(map["dentistId"])),
        await new AgreementService().getAgreementById(
            new GenericService().returnStringEmptyIfNull(map["agreementId"])),
        await new ProcedureService().getProcedureById(
            new GenericService().returnStringEmptyIfNull(map["procedureId"]))));
  }

  Future<bool> checkDuplicity() async {
    return ((await getAllAppointmentSchedulingByDateByHoraryByDentistId(
                appointmentScheduling.dateAppointmentScheduling,
                appointmentScheduling.horary,
                appointmentScheduling.dentistId))
            .length >
        1);
  }

  Future<bool> save() async {
    Map<bool, String> result = new Map<bool, String>();

    if (_appointmentScheduling == null) {
      return false;
    }

    Map<String, dynamic> datas = {
      "dateAppointmentScheduling":
          _appointmentScheduling.dateAppointmentScheduling,
      "agreementId": _appointmentScheduling.agreementId,
      "dentistId": _appointmentScheduling.dentistId,
      "shiftId": _appointmentScheduling.shiftId,
      "procedureId": _appointmentScheduling.procedureId,
      "patient": _appointmentScheduling.patient,
      "email": _appointmentScheduling.email,
      "tel": _appointmentScheduling.telephone,
      "horary": _appointmentScheduling.horary
    };

    if (_appointmentScheduling.id != "") {
      result[await new AppointmentSchedulingDAO()
              .update(_appointmentScheduling.id, datas) ==
          ""] = _appointmentScheduling.id;
    } else {
      result = await new AppointmentSchedulingDAO().save(datas);
    }

    return result.keys.first;
  }

  Future<bool> delete(String appointmentSchedulingId) async {
    bool result = true;

    result =
        (await new AppointmentSchedulingDAO().delete(appointmentSchedulingId))
            .isEmpty;

    return result;
  }
}
