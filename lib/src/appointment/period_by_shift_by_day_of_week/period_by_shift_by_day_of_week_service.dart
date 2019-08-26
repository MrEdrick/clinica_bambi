import 'dart:async';

import 'period_by_shift_by_day_of_week.dart';
import 'period_by_shift_by_day_of_week_dao.dart';

class PeriodByShiftByDayOfWeekService {
  static String _id;
  static PeriodByShiftByDayOfWeek _periodByShiftByDayOfWeekService;
  static Map _periodByShiftByDayOfWeekListById = new Map();
  static List<PeriodByShiftByDayOfWeek> _list =
      new List<PeriodByShiftByDayOfWeek>();
  static List<Map> _periodByShiftByDayOfWeekList = new List<Map>();
  static List<Map> _periodByShiftByDayOfWeekListWithFilter = new List<Map>();

  String get id => _id;
  set id(String id) => _id = id;

  PeriodByShiftByDayOfWeek get periodByShiftByDayOfWeekService =>
      _periodByShiftByDayOfWeekService;
  set periodByShiftByDayOfWeekService(
          PeriodByShiftByDayOfWeek periodByShiftByDayOfWeekService) =>
      _periodByShiftByDayOfWeekService = periodByShiftByDayOfWeekService;

  void clearAllPeriodByShiftByDayOfWeekList() {
    _list.clear();
    _periodByShiftByDayOfWeekList.clear();
    _periodByShiftByDayOfWeekListById.clear();
    _periodByShiftByDayOfWeekListWithFilter.clear();
  }

  Future<List<PeriodByShiftByDayOfWeek>>
      getAllPeriodByShiftByDayOfWeekAcives() async {
    if ((_periodByShiftByDayOfWeekList != null) &&
        (_periodByShiftByDayOfWeekList.length != 0)) {
      return _list;
    }

    clearAllPeriodByShiftByDayOfWeekList();

    await (_periodByShiftByDayOfWeekList =
        await new PeriodByShiftByDayOfWeekDAO()
            .getAllPeriodByShiftByDayOfWeekFilter(
                {"state": "A"}, {"description": "asc"}));

    _periodByShiftByDayOfWeekList.forEach((periodByShiftByDayOfWeek) {
      _periodByShiftByDayOfWeekListById[
          periodByShiftByDayOfWeek["documentPath"]] = periodByShiftByDayOfWeek;
      _list.add(turnMapInPeriodByShiftByDayOfWeek(periodByShiftByDayOfWeek));
    });

    return _list;
  }

  Future<PeriodByShiftByDayOfWeek> getPeriodByShiftByDayOfWeekById(
      String id) async {
    Map doc;

    if (id.isEmpty) {
      return returnEmptyPeriodByShiftByDayOfWeek();
    }

    if ((_periodByShiftByDayOfWeekList == null) ||
        (_periodByShiftByDayOfWeekList?.length == 0)) {
      await getAllPeriodByShiftByDayOfWeekAcives();
    }

    doc = _periodByShiftByDayOfWeekListById[id];

    if (doc == null) {
      doc = (await new PeriodByShiftByDayOfWeekDAO()
              .getAllPeriodByShiftByDayOfWeekFilter(
                  {'id': id}, {"description": "asc"}))
          .first;
    }

    return turnMapInPeriodByShiftByDayOfWeek(doc);
  }

  List<Map> getPeriodByShiftByDayOfWeekListWithFilterFromList(Map filter) {
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
    _periodByShiftByDayOfWeekList.forEach((shift) {
      _listDocumentSnapshot.add(shift);
    });

    _listDocumentSnapshotTemp.clear();

    if ((filter["description"] != null) && (filter["description"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["description"].toString().indexOf(filter["description"]) > -1) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["description"] != null) && (filter["description"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    if ((filter["shiftId"] != null) && (filter["shiftId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["shiftId"].toString() == filter["shiftId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["shiftId"] != null) && (filter["shiftId"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    if ((filter["dayOfWeek"] != null) && (filter["dayOfWeek"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["dayOfWeek"].toString().toUpperCase() ==
            filter["dayOfWeek"].toString().toUpperCase()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["dayOfWeek"] != null) && (filter["dayOfWeek"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    _periodByShiftByDayOfWeekListWithFilter = _listDocumentSnapshot;

    return _periodByShiftByDayOfWeekListWithFilter;
  }

  List<Map> getPeriodByShiftByDayOfWeekListWithFilter() {
    return _periodByShiftByDayOfWeekListWithFilter;
  }

  PeriodByShiftByDayOfWeek returnEmptyPeriodByShiftByDayOfWeek() {
    return new PeriodByShiftByDayOfWeek("", "", "", "", false);
  }

  PeriodByShiftByDayOfWeek turnMapInPeriodByShiftByDayOfWeek(Map map) {
    return new PeriodByShiftByDayOfWeek(map["documentPath"], map["shiftId"],
        map["dayOfWeek"], map["description"], map["state"]);
  }
}
