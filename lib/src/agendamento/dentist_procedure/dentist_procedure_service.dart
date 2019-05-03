import 'dentist_procedure.dart';
import 'dentist_procedure_dao.dart';

class DentistProcedureService {
  static DentistProcedure _dentistProcedure;
  static List<DentistProcedure> _list = new List<DentistProcedure>();
  static Map<String, DentistProcedure> _dentistProcedureListByDentistIdProcedureId = new Map();
  static List<Map> _dentistProcedureList = new List<Map>();
  static Map<String, DentistProcedure> _dentistProcedureListById = new Map();
  static List<Map> _dentistProcedureListWithFilter = new List<Map>();

  DentistProcedure get dentistProcedure => _dentistProcedure;
  set dentistProcedure(DentistProcedure dentistProcedure) =>
      _dentistProcedure = dentistProcedure;

  Map get dentistProcedureListByDentistIdProcedureId => _dentistProcedureListByDentistIdProcedureId;
  
  void clearAllDentistProcedureList() {
    _list.clear();
    _dentistProcedureList.clear();
    _dentistProcedureListById.clear();
    _dentistProcedureListWithFilter.clear();
    _dentistProcedureListByDentistIdProcedureId.clear();
  }

  Future<List<DentistProcedure>> getAllDentistProcedureAcives() async {
    if ((_dentistProcedureList != null) &&
        (_dentistProcedureList.length != 0)) {
      return _list;
    }

    clearAllDentistProcedureList();

    await (_dentistProcedureList =
        await (new DentistProcedureDAO().getAllDentistProcedureFilter({}, [])));

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

  Future<DentistProcedure> getOneDentistProcedureByFilter(Map filter) async {
    Map doc;
    List result;

    if ((_dentistProcedureList == null) ||
        (_dentistProcedureList.length == 0)) {
      await getAllDentistProcedureAcives();
    }

    result = getDentistProcedureListWithFilterFromList(filter);

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    if (doc == null) {
      result = (await new DentistProcedureDAO()
          .getAllDentistProcedureFilter(filter, ["=="]));

      if (result.length > 0) {
        doc = result?.first;
      } else {
        doc = null;
      }
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

  DentistProcedure turnMapInDentistProcedure(Map map) {
    if (map == null) {
      return null;
    }
    return new DentistProcedure(
        map["documentPath"], map["dentistId"], map["procedureId"]);
  }

  Future<bool> save(String dentistId) async {
    bool saved = false;

    if (_dentistProcedure == null) {
      return saved;
    }

    Map datas = {
      "dentistId": _dentistProcedure.dentistId,
      "procedureId": _dentistProcedure.procedureId
    };

    Map<bool, String> result = new Map<bool, String>();

    if (_dentistProcedure.id != "") {
      if ((_dentistProcedure.dentistId == "") &&
          (_dentistProcedure.procedureId == "")) {
        /*for (ComponentRef shiftByDayGroupComponent
            in shiftByDayGroupListComponent) {
          saved = await shiftByDayGroupComponent.instance.onSave();
          if (!saved) {
            break;
          }
        }*/

        if (saved) {
          result[await new DentistProcedureDAO().delete(_dentistProcedure.id) ==
              ""] = _dentistProcedure.id;
        }
      } else {
        result[await new DentistProcedureDAO()
                .update(_dentistProcedure.id, datas) ==
            ""] = _dentistProcedure.id;

        /*for (ComponentRef shiftByDayGroupComponent
            in shiftByDayGroupListComponent) {
          shiftByDayGroupComponent.instance.dentistProcedureId =
              result.values.first;

          saved = await shiftByDayGroupComponent.instance.onSave();
      
          if (!saved) {
            break;
          }
        }*/
      }
    } else {
      result = await new DentistProcedureDAO().save(datas);

      /*for (ComponentRef shiftByDayGroupComponent
          in shiftByDayGroupListComponent) {
        shiftByDayGroupComponent.instance.dentistProcedureId =
            result.values.first;

        saved = await shiftByDayGroupComponent.instance.onSave();

        if (!saved) {
          break;
        }
      }*/
    }
    return true;
  }
}
