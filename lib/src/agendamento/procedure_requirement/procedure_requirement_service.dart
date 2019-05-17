import 'procedure_requirement.dart';
import 'procedure_requirement_dao.dart';

class ProcedureRequirementService {
  static ProcedureRequirement _procedureRequirement;
  static List<ProcedureRequirement> _list = new List<ProcedureRequirement>();
  static Map<String, ProcedureRequirement>
      _procedureRequirementListByProcedureIdRequirementId = new Map();
  static List<Map> _procedureRequirementList = new List<Map>();
  static Map<String, ProcedureRequirement> _procedureRequirementListById = new Map();
  static List<Map> _procedureRequirementListWithFilter = new List<Map>();

  ProcedureRequirement get procedureRequirement => _procedureRequirement;
  set procedureRequirement(ProcedureRequirement procedureRequirement) =>
      _procedureRequirement = procedureRequirement;

  Map get procedureRequirementListByProcedureIdRequirementId =>
      _procedureRequirementListByProcedureIdRequirementId;

  void clearAllProcedureRequirementList() {
    _list.clear();
    _procedureRequirementList.clear();
    _procedureRequirementListById.clear();
    _procedureRequirementListWithFilter.clear();
    _procedureRequirementListByProcedureIdRequirementId.clear();
  }

  Future<List<ProcedureRequirement>> getAllProcedureRequirementAcives() async {
    if ((_procedureRequirementList != null) &&
        (_procedureRequirementList?.length != 0)) {
      return _list;
    }

    clearAllProcedureRequirementList();

    await (_procedureRequirementList = await (new ProcedureRequirementDAO()
        .getAllProcedureRequirementFilter({"isReal": "Y"}, ["=="])));

    _procedureRequirementList.forEach((procedureRequirement) {
      _procedureRequirementListById[procedureRequirement["documentPath"]] =
          turnMapInProcedureRequirement(procedureRequirement);

      _procedureRequirementListByProcedureIdRequirementId[
              procedureRequirement["procedureId"] + procedureRequirement["requirementeId"]] =
          turnMapInProcedureRequirement(procedureRequirement);

      _list.add(turnMapInProcedureRequirement(procedureRequirement));
    });

    return _list;
  }

  Future<ProcedureRequirement> getOneProcedureRequirementByFilterFromList(
      Map filter) async {
    Map doc;
    List result;

    result = getProcedureRequirementListWithFilterFromList(filter);

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    return turnMapInProcedureRequirement(doc);
  }

  Future<ProcedureRequirement> getOneProcedureRequirementByFilterFromDataBase(
      Map filter) async {
    Map doc;
    List result;

    result = (await new ProcedureRequirementDAO()
        .getAllProcedureRequirementFilter(filter, ["=="]));

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    return turnMapInProcedureRequirement(doc);
  }

  List<Map> getProcedureRequirementListWithFilterFromList(Map filter) {
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

    _listDocumentSnapshot = _procedureRequirementList;

    _listDocumentSnapshotTemp.clear();

    if ((filter["requirementId"] != null) && (filter["requirementId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["requirementId"].toString() == filter["requirementId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["requirementId"] != null) && (filter["requirementId"] != '')) {
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

    _procedureRequirementListWithFilter = _listDocumentSnapshot;

    return _procedureRequirementListWithFilter;
  }

  ProcedureRequirement turnMapInProcedureRequirement(Map map) {
    if (map == null) {
      return null;
    }
    return new ProcedureRequirement(
        map["documentPath"], map["procedureId"], map["requirementId"]);
  }


  Future<bool> save(String dentistId) async {
    if (_procedureRequirement == null) {
      return true;
    }

    Map datas = {
      "requirementId": _procedureRequirement.requirementId,
      "procedureId": _procedureRequirement.procedureId,
      "isReal": "Y"
    };

    Map<bool, String> result = new Map<bool, String>();

    if (_procedureRequirement.id != "") {
      if ((_procedureRequirement.requirementId == "") &&
          (_procedureRequirement.procedureId == "")) {

          result[await new ProcedureRequirementDAO().delete(_procedureRequirement.id) ==
              ""] = _procedureRequirement.id;
      } else {
        result[await new ProcedureRequirementDAO()
                .update(_procedureRequirement.id, datas) ==
            ""] = _procedureRequirement.id;
      }
    } else {
      
      if ((_procedureRequirement.requirementId != "") &&
          (_procedureRequirement.procedureId != "")) {
            
        result = await new ProcedureRequirementDAO().save(datas);
      }
    }

    return result.keys.first;
  }
}
