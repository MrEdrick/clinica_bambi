import 'dentist_quantity_per_shift.dart';
import 'dentist_quantity_per_shift_dao.dart';

class DentistQuantityPerShiftService {
  static DentistQuantityPerShift _dentistQuantityPerShift;
  static List<DentistQuantityPerShift> _list =
      new List<DentistQuantityPerShift>();
  static List<Map> _dentistQuantityPerShiftList = new List<Map>();
  static Map _dentistQuantityPerShiftListById = new Map();
  static List<Map> _dentistQuantityPerShiftListWithFilter = new List<Map>();

  DentistQuantityPerShift get dentistQuantityPerShift =>
      _dentistQuantityPerShift;
  set dentistQuantityPerShift(
          DentistQuantityPerShift dentistQuantityPerShift) =>
      _dentistQuantityPerShift = dentistQuantityPerShift;

  void clearAllDentistQuantityPerShiftList() {
    _list.clear();
    _dentistQuantityPerShiftList.clear();
    _dentistQuantityPerShiftListById.clear();
    _dentistQuantityPerShiftListWithFilter.clear();
  }

  Future<List<DentistQuantityPerShift>>
      getAllDentistQuantityPerShiftAcives() async {
    if ((_dentistQuantityPerShiftList != null) &&
        (_dentistQuantityPerShiftList.length != 0)) {
      return _list;
    }

    clearAllDentistQuantityPerShiftList();

    await (_dentistQuantityPerShiftList = await new DentistQuantityPerShiftDAO()
        .getAllDentistQuantityPerShiftFilter({}, []));

    _dentistQuantityPerShiftList.forEach((dentistQuantityPerShift) {
      _dentistQuantityPerShiftListById[
          dentistQuantityPerShift["documentPath"]] = dentistQuantityPerShift;
      _list.add(turnMapInDentistQuantityPerShift(dentistQuantityPerShift));
    });

    return _list;
  }

  Future<DentistQuantityPerShift> getOneDentistQuantityPerShiftByFilter(
      Map filter) async {
    Map doc;

    if ((_dentistQuantityPerShiftList == null) ||
        (_dentistQuantityPerShiftList.length == 0)) {
      await getAllDentistQuantityPerShiftAcives();
    }

    doc = getDentistQuantityPerShiftListWithFilterFromList(filter).first;

    if (doc == null) {
      doc = (await new DentistQuantityPerShiftDAO()
              .getAllDentistQuantityPerShiftFilter(filter, ["=="]))
          .first;
    }

    return turnMapInDentistQuantityPerShift(doc);
  }

  List<Map> getDentistQuantityPerShiftListWithFilterFromList(Map filter) {
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

    _listDocumentSnapshot = _dentistQuantityPerShiftList;

    _listDocumentSnapshotTemp.clear();

    if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["dentistId"].toString() == filter["dentistId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
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
        if (doc["dayOfWeek"].toString() == filter["dayOfWeek"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["dayOfWeek"] != null) && (filter["dayOfWeek"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    _dentistQuantityPerShiftListWithFilter = _listDocumentSnapshot;

    return _dentistQuantityPerShiftListWithFilter;
  }

  DentistQuantityPerShift turnMapInDentistQuantityPerShift(Map map) {
    return new DentistQuantityPerShift(
        map["documentPath"],
        map["dayOfWeek"],
        map["dentistId"],
        map["shiftId"],
        int.parse(map["quantity"].toString()));
  }
}
