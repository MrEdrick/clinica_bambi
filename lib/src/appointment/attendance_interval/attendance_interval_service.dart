import 'dart:async';

import '../../appointment/shift/shift_service.dart';
import '../../appointment/interval/interval_service.dart';
import '../../appointment/dentist/dentist_service.dart';
import '../../appointment/generic/generic_service.dart';

import 'attendance_interval.dart';
import 'attendance_interval_dao.dart';

class AttendanceIntervalService {
  static String _id;
  static AttendanceInterval _attendanceInterval;
  static Map _attendanceIntervalListById = new Map();
  static List<AttendanceInterval> _list = new List<AttendanceInterval>();
  static List<Map> _attendanceIntervalList = new List<Map>();
  static List<Map> _attendanceIntervalListWithFilter = new List<Map>();

  static Map<String, AttendanceInterval>
      _attendanceIntervalListByDentistIdShiftId =
      new Map<String, AttendanceInterval>();

  String get id => _id;
  set id(String id) => _id = id;

  AttendanceInterval get attendanceInterval => _attendanceInterval;
  set attendanceInterval(AttendanceInterval attendanceInterval) =>
      _attendanceInterval = attendanceInterval;

  Map<String, AttendanceInterval>
      get attendanceIntervalListByDentistIdShiftId =>
          _attendanceIntervalListByDentistIdShiftId;

  void clearAllAttendanceIntervalList() {
    _list.clear();
    _attendanceIntervalList.clear();
    _attendanceIntervalListById.clear();
    _attendanceIntervalListWithFilter.clear();
    _attendanceIntervalListByDentistIdShiftId.clear();
  }

  Future<List<AttendanceInterval>> getAllAttendanceIntervalAcives() async {
    if ((_attendanceIntervalList != null) &&
        (_attendanceIntervalList.length != 0)) {
      return _list;
    }

    clearAllAttendanceIntervalList();

    await (_attendanceIntervalList = await new AttendanceIntervalDAO()
        .getAllAttendanceIntervalFilter({}, {}));

    await _attendanceIntervalList.forEach((attendanceInterval) async {
      _attendanceIntervalListById[attendanceInterval["documentPath"]] =
          attendanceInterval;

      _attendanceIntervalListByDentistIdShiftId[
              attendanceInterval["dentistId"] + attendanceInterval["shiftId"]] =
          await turnMapInAttendanceInterval(attendanceInterval);

      _list.add(await turnMapInAttendanceInterval(attendanceInterval));
    });

    return _list;
  }

  Future<AttendanceInterval> getAttendanceIntervalById(String id) async {
    Map doc;

    if (id.isEmpty) {
      return returnEmptyAttendanceInterval();
    }

    if ((_attendanceIntervalList == null) ||
        (_attendanceIntervalList?.length == 0)) {
      await getAllAttendanceIntervalAcives();
    }

    doc = _attendanceIntervalListById[id];

    if (doc == null) {
      doc = (await new AttendanceIntervalDAO()
              .getAllAttendanceIntervalFilter({'id': id}, {}))
          .first;
    }

    return turnMapInAttendanceInterval(doc);
  }

  Future<AttendanceInterval> getAttendanceIntervalByDentistIdShiftId(
      String dentistId, String shiftId) async {
    //Map doc;

    if ((dentistId.isEmpty) || (shiftId.isEmpty)) {
      return returnEmptyAttendanceInterval();
    }

    if ((_attendanceIntervalList == null) ||
        (_attendanceIntervalList?.length == 0)) {
      await getAllAttendanceIntervalAcives();
    }
    
    return _attendanceIntervalListByDentistIdShiftId[dentistId + shiftId] ==
            null
        ? returnEmptyAttendanceInterval()
        : _attendanceIntervalListByDentistIdShiftId[dentistId + shiftId];
  }

  List<Map> getAttendanceIntervalListWithFilterFromList(Map filter) {
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
    _attendanceIntervalList.forEach((attendanceInterval) {
      _listDocumentSnapshot.add(attendanceInterval);
    });

    _listDocumentSnapshotTemp.clear();

    _attendanceIntervalListWithFilter = _listDocumentSnapshot;

    return _attendanceIntervalListWithFilter;
  }

  List<Map> getAttendanceIntervalListWithFilter() {
    return _attendanceIntervalListWithFilter;
  }

  AttendanceInterval returnEmptyAttendanceInterval() {
    return new AttendanceInterval(
        "",
        "",
        "",
        "",
        new DentistService().returnEmptyDentist(),
        new ShiftService().returnEmptyShift(),
        new IntervalService().returnEmptyInterval());
  }

  Future<AttendanceInterval> turnMapInAttendanceInterval(Map map) async {
    return await new AttendanceInterval(
      map["documentPath"],
      map["dentistId"],
      map["shiftId"],
      map["intervalId"],
      await new DentistService().getDentistById(
          new GenericService().returnStringEmptyIfNull(map["dentistId"])),
      await new ShiftService().getShiftById(
          new GenericService().returnStringEmptyIfNull(map["shiftId"])),
      await new IntervalService().getIntervalById(
          new GenericService().returnStringEmptyIfNull(map["intervalId"])),
    );
  }

  Future<bool> save() async {
    bool saved = false;

    if (_attendanceInterval == null) {
      return saved;
    }

    saved = true;

    Map datas = {
      "dentistId": _attendanceInterval.dentistId,
      "shiftId": _attendanceInterval.shiftId,
      "intervalId": _attendanceInterval.intervalId
    };

    Map<bool, String> result = new Map<bool, String>();

    if (_attendanceInterval.id != "") {
      result[await new AttendanceIntervalDAO()
              .update(_attendanceInterval.id, datas) ==
          ""] = _attendanceInterval.id;
    } else {
      result = await new AttendanceIntervalDAO().save(datas);
    }

    return saved;
  }
}
