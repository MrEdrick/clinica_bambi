import 'dart:async';

import 'shift.dart';
import 'shift_dao.dart';
import 'shiftUI.dart';

class ShiftService {
  static String _id;
  static Shift _shift;
  static Map _shiftListById = new Map();
  static List<Shift> _list = new List<Shift>();
  static List<Map> _shiftList = new List<Map>();
  static List<Map> _shiftListWithFilter = new List<Map>();

  String get id => _id;
  set id(String id) => _id = id;

  Shift get shift => _shift;
  set shift(Shift shift) => _shift = shift;

  void clearAllShiftList() {
    _list.clear();
    _shiftList.clear();
    _shiftListById.clear();
    _shiftListWithFilter.clear();
  }

  Future<List<Shift>> getAllShiftAcives() async {
    if ((_shiftList != null) && (_shiftList.length != 0)) {
      return _list;
    }

    clearAllShiftList();

    await (_shiftList = await new ShiftDAO()
        .getAllShiftFilter({"state": "A"}, {"description": "asc"}));

    _shiftList.forEach((shift) {
      _shiftListById[shift["documentPath"]] = shift;
      _list.add(turnMapInShift(shift));
    });

    return _list;
  }

  Future<List<ShiftUI>> getAllShiftUIAcives() async {
    if ((_shiftList == null) || (_shiftList.length == 0)) {
      await getAllShiftAcives();
    }

    List<ShiftUI> _listShiftUI = new List<ShiftUI>();

    for (Shift _shift in _list) {
      _listShiftUI.add(new ShiftUI(_shift.id, _shift.description));
    }

    return _listShiftUI;
  }

  Future<Shift> getShiftById(String id) async {
    Map doc;

    if (id.isEmpty) {
      return returnEmptyShift();
    }

    if ((_shiftList == null) || (_shiftList?.length == 0)) {
      await getAllShiftAcives();
    }

    doc = _shiftListById[id];

    if (doc == null) {
      doc = (await new ShiftDAO()
              .getAllShiftFilter({'id': id}, {"description": "asc"}))
          .first;
    }

    return turnMapInShift(doc);
  }

  List<Map> getShiftListWithFilterFromList(Map filter) {
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
    _shiftList.forEach((shift) {
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
    }

    ListsApplyFilter();

    _shiftListWithFilter = _listDocumentSnapshot;

    return _shiftListWithFilter;
  }

  List<Map> getShiftListWithFilter() {
    return _shiftListWithFilter;
  }

  Shift returnEmptyShift() {
    return new Shift("", "", "", 0, 0, 0, 0, false);
  }

  Shift turnMapInShift(Map map) {
    return new Shift(
        map["documentPath"],
        map["description"],
        map["observation"],
        int.parse(map["startTimeHour"]),
        int.parse(map["startTimeMinute"]),
        int.parse(map["endTimeHour"]),
        int.parse(map["endTimeMinute"]),
        map["state"]);
  }
}
