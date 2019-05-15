import 'dentist_procedure_by_day_of_week_by_shift.dart';
import 'dentist_procedure_by_day_of_week_by_shift_dao.dart';

class DentistProcedureByDayOfWeekByShiftService {
  static DentistProcedureByDayOfWeekByShift _dentistProcedureByDayOfWeekByShift;
  static Map
      _dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId =
      new Map();
  static List<DentistProcedureByDayOfWeekByShift> _list =
      new List<DentistProcedureByDayOfWeekByShift>();
  static List<Map> _dentistProcedureByDayOfWeekByShiftList = new List<Map>();
  static Map _dentistProcedureByDayOfWeekByShiftListById = new Map();
  static List<Map> _dentistProcedureByDayOfWeekByShiftListWithFilter =
      new List<Map>();

  DentistProcedureByDayOfWeekByShift get dentistProcedureByDayOfWeekByShift =>
      _dentistProcedureByDayOfWeekByShift;
  set dentistProcedureByDayOfWeekByShift(
          DentistProcedureByDayOfWeekByShift
              dentistProcedureByDayOfWeekByShift) =>
      _dentistProcedureByDayOfWeekByShift = dentistProcedureByDayOfWeekByShift;

  Map get dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId =>
    _dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId;

  void clearAllDentistProcedureByDayOfWeekByShiftList() {
    _list.clear();
    _dentistProcedureByDayOfWeekByShiftList.clear();
    _dentistProcedureByDayOfWeekByShiftListById.clear();
    _dentistProcedureByDayOfWeekByShiftListWithFilter.clear();
    _dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId.clear();
  }

  Future<List<DentistProcedureByDayOfWeekByShift>>
      getAllDentistProcedureByDayOfWeekByShiftAcives() async {
    if ((_dentistProcedureByDayOfWeekByShiftList != null) &&
        (_dentistProcedureByDayOfWeekByShiftList.length != 0)) {
      return _list;
    }

    clearAllDentistProcedureByDayOfWeekByShiftList();

    await (_dentistProcedureByDayOfWeekByShiftList =
        await new DentistProcedureByDayOfWeekByShiftDAO()
            .getAllDentistProcedureByDayOfWeekByShiftFilter({"isReal": "Y"}, ["=="]));

    _dentistProcedureByDayOfWeekByShiftList
        .forEach((dentistProcedureByDayOfWeekByShift) {

      _dentistProcedureByDayOfWeekByShiftListById[
              dentistProcedureByDayOfWeekByShift["documentPath"]] =
          turnMapInDentistProcedureByDayOfWeekByShift(dentistProcedureByDayOfWeekByShift);

      _dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
        dentistProcedureByDayOfWeekByShift["dentistProcedureByDayOfWeekId"] +
        dentistProcedureByDayOfWeekByShift["shiftId"]
      ] = turnMapInDentistProcedureByDayOfWeekByShift(dentistProcedureByDayOfWeekByShift);

      _list.add(turnMapInDentistProcedureByDayOfWeekByShift(
          dentistProcedureByDayOfWeekByShift));
    });

    return _list;
  }

  
  Future<DentistProcedureByDayOfWeekByShift>
      getOneDentistProcedureByDayOfWeekByShiftByFilterFromList(Map filter) async {
    Map doc;
    List result;

    result = getDentistProcedureByDayOfWeekByShiftListWithFilterFromList(filter);

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    return turnMapInDentistProcedureByDayOfWeekByShift(doc);
  }

  Future<DentistProcedureByDayOfWeekByShift>
      getOneDentistProcedureByDayOfWeekByShiftByFilterFromDataBase(Map filter) async {
    Map doc;
    List result;

    result = (await new DentistProcedureByDayOfWeekByShiftDAO()
        .getAllDentistProcedureByDayOfWeekByShiftFilter(filter, ["=="]));

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    return turnMapInDentistProcedureByDayOfWeekByShift(doc);
  }

  List<Map> getDentistProcedureByDayOfWeekByShiftListWithFilterFromList(
      Map filter) {
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

    if ((filter["dentistProcedureByDayOfWeekId"] != null) &&
        (filter["dentistProcedureByDayOfWeekId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["dentistProcedureByDayOfWeekId"].toString() ==
            filter["dentistProcedureByDayOfWeekId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["dentistProcedureByDayOfWeekId"] != null) &&
        (filter["dentistProcedureByDayOfWeekId"] != '')) {
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

    _dentistProcedureByDayOfWeekByShiftListWithFilter = _listDocumentSnapshot;

    return _dentistProcedureByDayOfWeekByShiftListWithFilter;
  }

  DentistProcedureByDayOfWeekByShift
      turnMapInDentistProcedureByDayOfWeekByShift(Map map) {
    if (map == null) {
      return null;
    }
    
    return new DentistProcedureByDayOfWeekByShift(map["documentPath"],
        map["dentistProcedureByDayOfWeekId"], map["shiftId"]);
  }

  Future<bool> save(String dentistProcedureByDayOfWeekId) async {
    bool saved = true;

    if (_dentistProcedureByDayOfWeekByShift == null) {
      return saved;
    }

    Map datas = {
      "dentistProcedureByDayOfWeekId": dentistProcedureByDayOfWeekId,
      "shiftId": _dentistProcedureByDayOfWeekByShift.shiftId,
      "isReal": "Y"
    };

    Map<bool, String> result = new Map<bool, String>();
    if (_dentistProcedureByDayOfWeekByShift.id != "") {
      if ((_dentistProcedureByDayOfWeekByShift.dentistProcedureByDayOfWeekId ==
              "") &&
          (_dentistProcedureByDayOfWeekByShift.shiftId == "")) {
            
        result[await new DentistProcedureByDayOfWeekByShiftDAO()
                .delete(_dentistProcedureByDayOfWeekByShift.id) ==
            ""] = _dentistProcedureByDayOfWeekByShift.id;
            
      } else {
        result[await new DentistProcedureByDayOfWeekByShiftDAO()
                .update(_dentistProcedureByDayOfWeekByShift.id, datas) ==
            ""] = _dentistProcedureByDayOfWeekByShift.id;
      }
    } else {
      result = await new DentistProcedureByDayOfWeekByShiftDAO().save(datas);
    }

    return result.keys.first;
  }
}
