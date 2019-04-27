import 'dentist_quantity_per_shift.dart';
import 'dentist_quantity_per_shift_dao.dart';

class DentistQuantityPerShiftService {
  static DentistQuantityPerShift _dentistQuantityPerShift;
  static List<DentistQuantityPerShift> _list = new List<DentistQuantityPerShift>();
  static List<Map> _dentistQuantityPerShiftList = new List<Map>();
  static Map _dentistQuantityPerShiftListById = new Map();
  static List<Map> _dentistQuantityPerShiftListWithFilter = new List<Map>();


  DentistQuantityPerShift get dentistQuantityPerShift => _dentistQuantityPerShift;
  set dentistQuantityPerShift(DentistQuantityPerShift dentistQuantityPerShift) =>
      _dentistQuantityPerShift = dentistQuantityPerShift;

  void clearAllDentistProcedureByDayOfWeekByShiftList() {
    _list.clear();
    _dentistProcedureByDayOfWeekByShiftList.clear();
    _dentistProcedureByDayOfWeekByShiftListById.clear();
    _dentistProcedureByDayOfWeekByShiftListWithFilter.clear();
  }

  Future<List<DentistProcedureByDayOfWeekByShift>> getAllDentistProcedureByDayOfWeekByShiftAcives() async {
    if ((_dentistProcedureByDayOfWeekByShiftList != null) && (_dentistProcedureByDayOfWeekByShiftList.length != 0)) {
      return _list;
    }

    clearAllDentistProcedureByDayOfWeekByShiftList();
    
    await (_dentistProcedureByDayOfWeekByShiftList = await new DentistProcedureByDayOfWeekByShiftDAO()
        .getAllDentistProcedureByDayOfWeekByShiftFilter({}, []));
    
    _dentistProcedureByDayOfWeekByShiftList.forEach((dentistProcedureByDayOfWeekByShift) {
      _dentistProcedureByDayOfWeekByShiftListById[dentistProcedureByDayOfWeekByShift["documentPath"]] = dentistProcedureByDayOfWeekByShift;
      _list.add(turnMapInDentistProcedureByDayOfWeekByShift(dentistProcedureByDayOfWeekByShift));
    });
    
    return _list;
  }

  Future<DentistProcedureByDayOfWeekByShift> getOneDentistProcedureByDayOfWeekByShiftByFilter(Map filter) async {
    Map doc;

    if ((_dentistProcedureByDayOfWeekByShiftList == null) || (_dentistProcedureByDayOfWeekByShiftList.length == 0)) {
      await getAllDentistProcedureByDayOfWeekByShiftAcives();
    }

    doc = getDentistProcedureByDayOfWeekByShiftListWithFilterFromList(filter).first;

    if (doc == null) {
      doc = (await new DentistProcedureByDayOfWeekByShiftDAO()
              .getAllDentistProcedureByDayOfWeekByShiftFilter(filter, ["=="]))
          .first;
    }

    return turnMapInDentistProcedureByDayOfWeekByShift(doc);
  }

List<Map> getDentistProcedureByDayOfWeekByShiftListWithFilterFromList(Map filter) {
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

    _listDocumentSnapshot = _dentistProcedureByDayOfWeekByShiftList;

    _listDocumentSnapshotTemp.clear();

    if ((filter["dentistProcedureByDayOfWeekId"] != null) && (filter["dentistProcedureByDayOfWeekId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["dentistProcedureByDayOfWeekId"].toString() == filter["dentistProcedureByDayOfWeekId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["dentistProcedureByDayOfWeekId"] != null) && (filter["dentistProcedureByDayOfWeekId"] != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    if ((filter["shiftId"] != null) && (filter["shiftId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["shiftId"].toString() == filter["shiftId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["shiftId"] != null) && (filter["shiftId"] != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    _dentistProcedureByDayOfWeekByShiftListWithFilter = _listDocumentSnapshot;
    
    return _dentistProcedureByDayOfWeekByShiftListWithFilter;
  }


  DentistProcedureByDayOfWeekByShift turnMapInDentistProcedureByDayOfWeekByShift(Map map) {
    return new DentistProcedureByDayOfWeekByShift(map["documentPath"], map["dentistProcedureIdByDayOfWeek"], map["shiftId"]);
  }
}