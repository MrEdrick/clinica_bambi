import 'dart:async';

import 'shift.dart';
import 'shift_dao.dart';
import 'shiftUI.dart';
import '../../firebase/firestore.dart';

class ShiftService {
  static List<Shift> _list = new List<Shift>();
  static Shift _shift;
  static List<Map> _shiftList = new List<Map>();
  static Map _shiftListById = new Map();
  static List<Map> _shiftListWithFilter = new List<Map>();

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

    if ((_shiftList == null) || (_shiftList.length == 0)) {
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

    _listDocumentSnapshot = _shiftList;

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

  Shift turnMapInShift(Map map) {
    return new Shift(map["documentPath"], map["description"], map["state"]);
  }

  /*Future<Shift> getShiftById(String shiftId, String hourId) async {
    if ((shiftId == '') || (shiftId == null)) {
      if ((hourId == 'JVWNJdwwqjFXCbmuGWf0')
          || (hourId == 'Q14M2Diimon1ksVLO3TO')
          || (hourId == 'hql4fUJfU8vhoxaF7IkB')
          || (hourId == 'mUFFpnp6CP53gnEuS9DU')) {
          shiftId = '1a5XNjDT8qfLQ53KSSxh';
      } else {
          shiftId = 'fBXihJRGPTPepfkfbxSs';
      }
    }

    if (_list == null) {
      await getAllShiftAcives();
    }

    for (var i = 0; i < _list.length; i++) {
      if (_list[i].shiftId == shiftId) {
        return _list[i];
      }
    };

     return null;
  }*/

}