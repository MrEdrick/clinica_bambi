import 'dentist_procedure.dart';
import 'dentist_procedure_dao.dart';
import '../dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week_service.dart';
import '../dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week.dart';

class DentistProcedureService {
  static DentistProcedure _dentistProcedure;
  static List<DentistProcedure> _list = new List<DentistProcedure>();
  static Map<String, DentistProcedure>
      _dentistProcedureListByDentistIdProcedureId = new Map();
  static List<Map> _dentistProcedureList = new List<Map>();
  static Map<String, DentistProcedure> _dentistProcedureListById = new Map();
  static List<Map> _dentistProcedureListWithFilter = new List<Map>();

  DentistProcedure get dentistProcedure => _dentistProcedure;
  set dentistProcedure(DentistProcedure dentistProcedure) =>
      _dentistProcedure = dentistProcedure;

  Map get dentistProcedureListByDentistIdProcedureId =>
      _dentistProcedureListByDentistIdProcedureId;

  void clearAllDentistProcedureList() {
    _list.clear();
    _dentistProcedureList.clear();
    _dentistProcedureListById.clear();
    _dentistProcedureListWithFilter.clear();
    _dentistProcedureListByDentistIdProcedureId.clear();
  }

  Future<List<DentistProcedure>> getAllDentistProcedureAcives() async {
    if ((_dentistProcedureList != null) &&
        (_dentistProcedureList?.length != 0)) {
      return _list;
    }

    clearAllDentistProcedureList();

    await (_dentistProcedureList = await (new DentistProcedureDAO()
        .getAllDentistProcedureFilter({"isReal": "Y"}, ["=="])));

    _dentistProcedureList.forEach((dentistProcedure) {
      _dentistProcedureListById[dentistProcedure["documentPath"]] =
          turnMapInDentistProcedure(dentistProcedure);

      _dentistProcedureListByDentistIdProcedureId[
              dentistProcedure["dentistId"] + dentistProcedure["procedureId"]] =
          turnMapInDentistProcedure(dentistProcedure);

      _list.add(turnMapInDentistProcedure(dentistProcedure));
    });

    return _list;
  }

  Future<DentistProcedure> getOneDentistProcedureByFilterFromList(
      Map filter) async {
    Map doc;
    List result;

    result = getDentistProcedureListWithFilterFromList(filter);

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    return turnMapInDentistProcedure(doc);
  }

  Future<DentistProcedure> getOneDentistProcedureByFilterFromDataBase(
      Map filter) async {
    Map doc;
    List result;

    result = (await new DentistProcedureDAO()
        .getAllDentistProcedureFilter(filter, ["=="]));

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    return turnMapInDentistProcedure(doc);
  }

  List<Map> getDentistProcedureListWithFilterFromList(Map filter) {
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

    _listDocumentSnapshot = _dentistProcedureList;

    print(_listDocumentSnapshot);
    print(filter);

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

    if ((filter["procedureId"] != null) && (filter["procedureId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["procedureId"].toString() == filter["procedureId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["procedureId"] != null) && (filter["procedureId"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    _dentistProcedureListWithFilter = _listDocumentSnapshot;

    return _dentistProcedureListWithFilter;
  }

  Future<List<String>> returnDentistIdListByProcedureId(
      String procedureId) async {
    if (_dentistProcedureList.isEmpty) {
      await getAllDentistProcedureAcives();
    }

    List<String> listId = new List<String>();
    listId.clear();
    getDentistProcedureListWithFilterFromList({"procedureId": procedureId})
        .forEach((map) {
      listId.add(map["dentistId"]);
    });

    return listId;
  }

  DentistProcedure turnMapInDentistProcedure(Map map) {
    if (map == null) {
      return null;
    }
    return new DentistProcedure(
        map["documentPath"], map["dentistId"], map["procedureId"]);
  }

  Future<bool> deleteDentistProcedureByDayOfWeekList(
      String dentistProcedureId) async {
    bool saved = true;
    DentistProcedureByDayOfWeekService _dentistProcedureByDayOfWeekService =
        new DentistProcedureByDayOfWeekService();

    for (DentistProcedureByDayOfWeek dentistProcedureByDayOfWeek
        in _dentistProcedureByDayOfWeekService
            .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek
            .values) {
      _dentistProcedureByDayOfWeekService.dentistProcedureByDayOfWeek =
          dentistProcedureByDayOfWeek;
      _dentistProcedureByDayOfWeekService
          .dentistProcedureByDayOfWeek.dentistProcedureId = "";
      _dentistProcedureByDayOfWeekService
          .dentistProcedureByDayOfWeek.dayOfWeek = "";
      saved = await (_dentistProcedureByDayOfWeekService.save(
          dentistProcedureId, ""));

      if (!saved) {
        break;
      }
    }

    if (saved) {
      _dentistProcedureByDayOfWeekService
          .clearAllDentistProcedureByDayOfWeekList();
    }

    return saved;
  }

  Future<bool> saveDentistProcedureByDayOfWeekList(
      String dentistProcedureId, String procedureId) async {
    bool saved = true;
    DentistProcedureByDayOfWeekService _dentistProcedureByDayOfWeekService =
        new DentistProcedureByDayOfWeekService();

    for (String key in _dentistProcedureByDayOfWeekService
        .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek.keys) {
      if ((key.indexOf(dentistProcedureId) > -1) ||
          (key.indexOf(procedureId) > -1)) {
        _dentistProcedureByDayOfWeekService.dentistProcedureByDayOfWeek =
            _dentistProcedureByDayOfWeekService
                    .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
                key];

        saved = await (_dentistProcedureByDayOfWeekService.save(
            dentistProcedureId, procedureId));
        if (!saved) {
          break;
        }
      }
    }

    return saved;
  }

  Future<bool> save(String dentistId) async {
    bool saved = true;

    if (_dentistProcedure == null) {
      return saved;
    }

    Map datas = {
      "dentistId": _dentistProcedure.dentistId,
      "procedureId": _dentistProcedure.procedureId,
      "isReal": "Y"
    };

    Map<bool, String> result = new Map<bool, String>();

    if (_dentistProcedure.id != "") {
      if ((_dentistProcedure.dentistId == "") &&
          (_dentistProcedure.procedureId == "")) {
        saved =
            await deleteDentistProcedureByDayOfWeekList(_dentistProcedure.id);

        if (saved) {
          result[await new DentistProcedureDAO().delete(_dentistProcedure.id) ==
              ""] = _dentistProcedure.id;
        }
      } else {
        result[await new DentistProcedureDAO()
                .update(_dentistProcedure.id, datas) ==
            ""] = _dentistProcedure.id;

        saved = await saveDentistProcedureByDayOfWeekList(
            result.values.first, dentistProcedure.procedureId);
      }
    } else {
      if ((_dentistProcedure.dentistId != "") &&
          (_dentistProcedure.procedureId != "")) {
        result = await new DentistProcedureDAO().save(datas);

        saved = await saveDentistProcedureByDayOfWeekList(
            result.values.first, dentistProcedure.procedureId);
      }
    }

    return saved;
  }
}
