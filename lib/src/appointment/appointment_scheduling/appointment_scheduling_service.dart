import 'dart:async';
import 'appointment_scheduling.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/angular_components.dart';
import 'appointment_scheduling_dao.dart';

import 'package:firebase/firebase.dart' as fb;
import '../../appointment/shift/shift_service.dart';
import '../../appointment/agreement/agreement_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling_service.dart';
import '../../appointment/generic/generic_service.dart';

class AppointmentSchedulingService {
  static AppointmentScheduling _appointmentScheduling;
  static Map _appointmentSchedulingById = new Map();
  static Map _appointmentSchedulingByDate = new Map();
  static Map _appointmentSchedulingByDateWithFilter = new Map();

  AppointmentScheduling get appointmentScheduling => _appointmentScheduling;
  set appointmentScheduling(AppointmentScheduling appointmentScheduling) =>
      _appointmentScheduling = appointmentScheduling;

  void clearAllAppointmentSchedulingByDate() {
    _appointmentSchedulingByDate.clear();
    _appointmentSchedulingByDateWithFilter.clear();
    _appointmentSchedulingById.clear();
  }

  Future<Map> getAllAppointmentSchedulingByDate(Date date) async {
    if ((_appointmentSchedulingByDate != null) &&
        (_appointmentSchedulingByDate?.length != 0)) {
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

  Map getAppointmentScheduling() {
    return _appointmentSchedulingById;
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

    _listDocumentSnapshot.clear();
    _appointmentSchedulingByDate[date.toString()]
        .forEach((appointmentSchedulingByDate) {
      _listDocumentSnapshot.add(appointmentSchedulingByDate);
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

    _appointmentSchedulingByDateWithFilter[date] = _listDocumentSnapshot;

    return _appointmentSchedulingByDateWithFilter[date];
  }

  List<Map> getAppointmentSchedulingFromListWithFilterByDate(String date) {
    return _appointmentSchedulingByDateWithFilter[date];
  }

  Future<AppointmentScheduling> getAppointmentSchedulingById(String id) async {
    Map doc;

    doc = _appointmentSchedulingById[id];

    if (doc == null) {
      List<Map> _list = (await new AppointmentSchedulingDAO()
              .getAllAppointmentSchedulingFilter({'id': id}));

      if (_list.isNotEmpty) {
        doc = _list.first;
      } else {
        return returnEmptyAppointmentShceduling();
      }
    }

    return await turnMapInAppointmentScheduling(doc);
  }

  Future<AppointmentScheduling>
      getAppointmentSchedulingByAutoAppointmentSchedulingId(
          String autoAppointmentSchedulingId) async {
    List<Map> list;

    list = (await new AppointmentSchedulingDAO()
        .getAllAppointmentSchedulingFilter(
            {'autoAppointmentSchedulingId': autoAppointmentSchedulingId}));

    if (list.length == 0) {
      return returnEmptyAppointmentShceduling();
    } else {
      return await turnMapInAppointmentScheduling(list.first);
    }
  }

  Future<AppointmentScheduling> getAppointmentSchedulingByFilterFromDB(
      Map filter) async {
    Map doc;

    doc = (await new AppointmentSchedulingDAO()
            .getAllAppointmentSchedulingFilter(filter))
        .first;

    return await turnMapInAppointmentScheduling(doc);
  }

  AppointmentScheduling returnEmptyAppointmentShceduling() {
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
        '',
        '',
        new ShiftService().returnEmptyShift(),
        new DentistService().returnEmptyDentist(),
        new AgreementService().returnEmptyAgreement(),
        new AutoAppointmentSchedulingService()
            .returnEmptyAutoAppointmentScheduling());
  }

  Future<int> returnQuantityAppointmentSchedulingByFilterFromDataBase(
      Map filter) async {
    return (await (new AppointmentSchedulingDAO()
            .getAllAppointmentSchedulingFilter(filter)))
        .length;
  }

  Future<AppointmentScheduling> turnMapInAppointmentScheduling(Map map) async {
    return await (new AppointmentScheduling(
        map["documentPath"],
        map["dateAppointmentScheduling"],
        new GenericService().returnStringEmptyIfNull(map["hourId"]),
        new GenericService().returnStringEmptyIfNull(map["minuteId"]),
        new GenericService().returnStringEmptyIfNull(map["shiftId"]),
        new GenericService().returnStringEmptyIfNull(map["dentistId"]),
        new GenericService().returnStringEmptyIfNull(map["agreementId"]),
        new GenericService()
            .returnStringEmptyIfNull(map["autoAppointmentSchedulingId"]),
        map["patient"],
        map["email"],
        new GenericService().returnStringEmptyIfNull(map["tel"]),
        map["userId"],
        map["horary"],
        await new ShiftService().getShiftById(
            new GenericService().returnStringEmptyIfNull(map["shiftId"])),
        await new DentistService().getDentistById(
            new GenericService().returnStringEmptyIfNull(map["dentistId"])),
        await new AgreementService().getAgreementById(
            new GenericService().returnStringEmptyIfNull(map["agreementId"])),
        await new AutoAppointmentSchedulingService()
            .returnEmptyAutoAppointmentScheduling()));
  }

  Future<bool> save() async {
    bool saved = true;
    Map<bool, String> result = new Map<bool, String>();

    if (_appointmentScheduling == null) {
      return saved;
    }

    Map<String, dynamic> datas = {
      "dateAppointmentScheduling":
          _appointmentScheduling.dateAppointmentScheduling,
      "shiftId": _appointmentScheduling.shiftId,
      "agreementId": _appointmentScheduling.agreementId,
      "dentistId": _appointmentScheduling.dentistId,
      "autoAppointmentSchedulingId":
          _appointmentScheduling.autoAppointmentSchedulingId,
      "patient": _appointmentScheduling.patient,
      "email": _appointmentScheduling.email,
      "tel": _appointmentScheduling.telephone,
      "userId": fb.auth().currentUser.uid,
      "horary": _appointmentScheduling.horary
    };

    if (_appointmentScheduling.id != '') {
      result[await new AppointmentSchedulingDAO()
              .update(_appointmentScheduling.id, datas) ==
          ""] = _appointmentScheduling.id;
    } else {
      result = await new AppointmentSchedulingDAO().save(datas);
    }

    return saved;
  }

  Future<bool> delete(String appointmentSchedulingId) async {
    return (await new AppointmentSchedulingDAO()
            .delete(appointmentSchedulingId))
        .isEmpty;
  }
}
