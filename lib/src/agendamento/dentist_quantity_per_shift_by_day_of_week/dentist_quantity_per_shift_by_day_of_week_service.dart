import 'dentist_quantity_per_shift_by_day_of_week.dart';
import 'dentist_quantity_per_shift_by_day_of_week_dao.dart';

class DentistQuantityPerShiftByDayOfWeekService {
  static DentistQuantityPerShiftByDayOfWeek _dentistQuantityPerShiftByDayOfWeek;
  static List<DentistQuantityPerShiftByDayOfWeek> _list =
      new List<DentistQuantityPerShiftByDayOfWeek>();
  static List<Map> _dentistQuantityPerShiftByDayOfWeekList = new List<Map>();
  static Map _dentistQuantityPerShiftByDayOfWeekListById = new Map();
  static List<Map> _dentistQuantityPerShiftByDayOfWeekListWithFilter = new List<Map>();

  DentistQuantityPerShiftByDayOfWeek get dentistQuantityPerShiftByDayOfWeek =>
      _dentistQuantityPerShiftByDayOfWeek;
  set dentistQuantityPerShiftByDayOfWeek(
          DentistQuantityPerShiftByDayOfWeek dentistQuantityPerShiftByDayOfWeek) =>
      _dentistQuantityPerShiftByDayOfWeek = dentistQuantityPerShiftByDayOfWeek;

  void clearAllDentistQuantityPerShiftByDayOfWeekList() {
    _list.clear();
    _dentistQuantityPerShiftByDayOfWeekList.clear();
    _dentistQuantityPerShiftByDayOfWeekListById.clear();
    _dentistQuantityPerShiftByDayOfWeekListWithFilter.clear();
  }

  Future<List<DentistQuantityPerShiftByDayOfWeek>>
      getAllDentistQuantityPerShiftByDayOfWeekAcives() async {
    if ((_dentistQuantityPerShiftByDayOfWeekList != null) &&
        (_dentistQuantityPerShiftByDayOfWeekList.length != 0)) {
      return _list;
    }

    clearAllDentistQuantityPerShiftByDayOfWeekList();

    await (_dentistQuantityPerShiftByDayOfWeekList = await new DentistQuantityPerShiftByDayOfWeekDAO()
        .getAllDentistQuantityPerShiftByDayOfWeekFilter({}, []));

    _dentistQuantityPerShiftByDayOfWeekList.forEach((dentistQuantityPerShiftByDayOfWeek) {
      _dentistQuantityPerShiftByDayOfWeekListById[
          dentistQuantityPerShiftByDayOfWeek["documentPath"]] = dentistQuantityPerShiftByDayOfWeek;
      _list.add(turnMapInDentistQuantityPerShiftByDayOfWeek(dentistQuantityPerShiftByDayOfWeek));
    });

    return _list;
  }

  Future<DentistQuantityPerShiftByDayOfWeek> getOneDentistQuantityPerShiftByDayOfWeekByFilter(
      Map filter) async {
    Map doc;

    if ((_dentistQuantityPerShiftByDayOfWeekList == null) ||
        (_dentistQuantityPerShiftByDayOfWeekList.length == 0)) {
      await getAllDentistQuantityPerShiftByDayOfWeekAcives();
    }

    doc = getDentistQuantityPerShiftByDayOfWeekListWithFilterFromList(filter).first;

    if (doc == null) {
      doc = (await new DentistQuantityPerShiftByDayOfWeekDAO()
              .getAllDentistQuantityPerShiftByDayOfWeekFilter(filter, ["=="]))
          .first;
    }

    return turnMapInDentistQuantityPerShiftByDayOfWeek(doc);
  }

  List<Map> getDentistQuantityPerShiftByDayOfWeekListWithFilterFromList(Map filter) {
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

    _listDocumentSnapshot = _dentistQuantityPerShiftByDayOfWeekList;

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

    _dentistQuantityPerShiftByDayOfWeekListWithFilter = _listDocumentSnapshot;

    return _dentistQuantityPerShiftByDayOfWeekListWithFilter;
  }

  DentistQuantityPerShiftByDayOfWeek turnMapInDentistQuantityPerShiftByDayOfWeek(Map map) {
    return new DentistQuantityPerShiftByDayOfWeek(
        map["documentPath"],
        map["dayOfWeek"],
        map["dentistId"],
        map["shiftId"],
        int.parse(map["quantity"].toString()));
  }
}
