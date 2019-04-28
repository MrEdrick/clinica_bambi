import 'dentist_procedure_by_day_of_week.dart';
import 'dentist_procedure_by_day_of_week_dao.dart';

class DentistProcedureByDayOfWeekService {
  static DentistProcedureByDayOfWeek _dentistProcedureByDayOfWeek;
  static List<DentistProcedureByDayOfWeek> _list =
      new List<DentistProcedureByDayOfWeek>();
  static List<Map> _dentistProcedureByDayOfWeekList = new List<Map>();
  static Map _dentistProcedureByDayOfWeekListById = new Map();
  static List<Map> _dentistProcedureByDayOfWeekListWithFilter = new List<Map>();

  DentistProcedureByDayOfWeek get dentistProcedureByDayOfWeek =>
      _dentistProcedureByDayOfWeek;
  set dentistProcedureByDayOfWeek(
          DentistProcedureByDayOfWeek dentistProcedureByDayOfWeek) =>
      _dentistProcedureByDayOfWeek = dentistProcedureByDayOfWeek;

  void clearAllDentistProcedureByDayOfWeekList() {
    _list.clear();
    _dentistProcedureByDayOfWeekList.clear();
    _dentistProcedureByDayOfWeekListById.clear();
    _dentistProcedureByDayOfWeekListWithFilter.clear();
  }

  Future<List<DentistProcedureByDayOfWeek>>
      getAllDentistProcedureByDayOfWeekAcives() async {
    if ((_dentistProcedureByDayOfWeekList != null) &&
        (_dentistProcedureByDayOfWeekList.length != 0)) {
      return _list;
    }

    clearAllDentistProcedureByDayOfWeekList();

    await (_dentistProcedureByDayOfWeekList =
        await new DentistProcedureByDayOfWeekDAO()
            .getAllDentistProcedureByDayOfWeekFilter({}, []));

    _dentistProcedureByDayOfWeekList.forEach((dentistProcedureByDayOfWeek) {
      _dentistProcedureByDayOfWeekListById[
              dentistProcedureByDayOfWeek["documentPath"]] =
          dentistProcedureByDayOfWeek;
      _list.add(
          turnMapInDentistProcedureByDayOfWeek(dentistProcedureByDayOfWeek));
    });

    return _list;
  }

  Future<DentistProcedureByDayOfWeek> getOneDentistProcedureByDayOfWeekByFilter(
      Map filter) async {
    Map doc;
    List result;

    if ((_dentistProcedureByDayOfWeekList == null) ||
        (_dentistProcedureByDayOfWeekList.length == 0)) {
      await getAllDentistProcedureByDayOfWeekAcives();
    }

    result = getDentistProcedureByDayOfWeekListWithFilterFromList(filter);

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    if (doc == null) {
      result = (await new DentistProcedureByDayOfWeekDAO()
          .getAllDentistProcedureByDayOfWeekFilter(filter, ["=="]));

      if (result.length > 0) {
        doc = result?.first;
      } else {
        doc = null;
      }
    }

    return turnMapInDentistProcedureByDayOfWeek(doc);
  }

  List<Map> getDentistProcedureByDayOfWeekListWithFilterFromList(Map filter) {
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

    _listDocumentSnapshot = _dentistProcedureByDayOfWeekList;

    _listDocumentSnapshotTemp.clear();

    if ((filter["dentistProcedureId"] != null) &&
        (filter["dentistProcedureId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["dentistProcedureId"].toString() ==
            filter["dentistProcedureId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["dentistProcedureId"] != null) &&
        (filter["dentistProcedureId"] != '')) {
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

    _dentistProcedureByDayOfWeekListWithFilter = _listDocumentSnapshot;

    return _dentistProcedureByDayOfWeekListWithFilter;
  }

  DentistProcedureByDayOfWeek turnMapInDentistProcedureByDayOfWeek(Map map) {
    if (map == null) {
      return null;
    }
    return new DentistProcedureByDayOfWeek(
        map["documentPath"], map["dentistProcedureId"], map["dayOfWeek"]);
  }
}
