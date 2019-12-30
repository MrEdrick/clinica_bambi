import 'dart:async';

import 'attendance_interval.dart';
import 'attendance_interval_dao.dart';

class ShiftService {
  static String _id;
  static AttendanceInterval _attendanceInterval;
  static Map _attendanceIntervalListById = new Map();
  static List<AttendanceInterval> _list = new List<AttendanceInterval>();
  static List<Map> _attendanceIntervalList = new List<Map>();
  static List<Map> _attendanceIntervalListWithFilter = new List<Map>();

  String get id => _id;
  set id(String id) => _id = id;

  AttendanceInterval get attendanceInterval => _attendanceInterval;
  set attendanceInterval(AttendanceInterval attendanceInterval) =>
      _attendanceInterval = attendanceInterval;

  void clearAllAttendanceIntervalList() {
    _list.clear();
    _attendanceIntervalList.clear();
    _attendanceIntervalListById.clear();
    _attendanceIntervalListWithFilter.clear();
  }

  Future<List<AttendanceInterval>> getAllAttendanceIntervalAcives() async {
    if ((_attendanceIntervalList != null) &&
        (_attendanceIntervalList.length != 0)) {
      return _list;
    }

    clearAllAttendanceIntervalList();

    await (_attendanceIntervalList = await new AttendanceIntervalDAO()
        .getAllAttendanceIntervalFilter({}, {}));

    _attendanceIntervalList.forEach((attendanceInterval) {
      _attendanceIntervalListById[attendanceInterval["documentPath"]] =
          attendanceInterval;
      _list.add(turnMapInAttendanceInterval(attendanceInterval));
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
    return new AttendanceInterval("", "", "", "");
  }

  AttendanceInterval turnMapInAttendanceInterval(Map map) {
    return new AttendanceInterval(map["documentPath"], map["dentistId"],
        map["shiftId"], map["intervalId"]);
  }
}
