import 'dart:async';

import 'interval.dart';
import 'interval_dao.dart';
import 'intervalUI.dart';

class IntervalService {
  static String _id;
  static Interval _interval;
  static Map _intervalListById = new Map();
  static List<Interval> _list = new List<Interval>();
  static List<Map> _intervalList = new List<Map>();
  static List<Map> _intervalListWithFilter = new List<Map>();

  String get id => _id;
  set id(String id) => _id = id;

  Interval get interval => _interval;
  set interval(Interval interval) => _interval = interval;

  void clearAllIntervalList() {
    _list.clear();
    _intervalList.clear();
    _intervalListById.clear();
    _intervalListWithFilter.clear();
  }

  Future<List<Interval>> getAllIntervalAcives() async {
    if ((_intervalList != null) && (_intervalList.length != 0)) {
      return _list;
    }

    clearAllIntervalList();

    await (_intervalList = await new IntervalDAO()
        .getAllIntervalFilter({"state": "A"}, {"time": "asc"}));

    _intervalList.forEach((interval) {
      _intervalListById[interval["documentPath"]] = interval;
      _list.add(turnMapInInterval(interval));
    });

    return _list;
  }

  Future<List<IntervalUI>> getAllIntervalUIAcives() async {
    if ((_intervalList == null) || (_intervalList.length == 0)) {
      await getAllIntervalAcives();
    }

    List<IntervalUI> _listIntervalUI = new List<IntervalUI>();

    for (Interval _interval in _list) {
      _listIntervalUI
          .add(new IntervalUI(_interval.id, _interval.time.toString()));
    }

    return _listIntervalUI;
  }

  Future<Interval> getIntervalById(String id) async {
    Map doc;

    if (id.isEmpty) {
      return returnEmptyInterval();
    }

    if ((_intervalList == null) || (_intervalList?.length == 0)) {
      await getAllIntervalAcives();
    }

    doc = _intervalListById[id];

    if (doc == null) {
      List<Map> _list = (await new IntervalDAO()
          .getAllIntervalFilter({'id': id}, {"time": "asc"}));

      if (_list.isNotEmpty) {
        doc = _list.first;
      } else {
        return returnEmptyInterval();
      }
    }

    return turnMapInInterval(doc);
  }

  List<Map> getIntervalListWithFilterFromList(Map filter) {
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
    _intervalList.forEach((_interval) {
      _listDocumentSnapshot.add(_interval);
    });

    _listDocumentSnapshotTemp.clear();

    _intervalListWithFilter = _listDocumentSnapshot;

    return _intervalListWithFilter;
  }

  List<Map> getIntervalListWithFilter() {
    return _intervalListWithFilter;
  }

  Interval returnEmptyInterval() {
    return new Interval("", 0, false);
  }

  Interval turnMapInInterval(Map map) {
    return new Interval(map["documentPath"], map["time"], map["state"]);
  }
}
