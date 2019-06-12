import 'requirement.dart';
import 'requirement_dao.dart';

class RequirementService {
  static List<Requirement> _list = new List<Requirement>();
  static Requirement _requirement;
  static List<Map> _requirementList = new List<Map>();
  static Map<String, Requirement> _requirementListById =
      new Map<String, Requirement>();
  static List<Map> _requirementListWithFilter = new List<Map>();

  Requirement get requirement => _requirement;
  set requirement(Requirement requirement) => _requirement = requirement;

  void clearAllRequirementList() {
    _list.clear();
    _requirementList.clear();
    _requirementListById.clear();
    _requirementListWithFilter.clear();
  }

  Future<List<Requirement>> getAllRequirementAcives() async {
    if ((_requirementList != null) && (_requirementList.length != 0)) {
      return _list;
    }

    clearAllRequirementList();

    await (_requirementList = await new RequirementDAO()
        .getAllRequirementFilter({"state": "A"}, {"description": "asc"}));

    _requirementList.forEach((requirement) {
      _requirementListById[requirement["documentPath"]] =
          turnMapInRequirement(requirement);
      _list.add(turnMapInRequirement(requirement));
    });

    return _list;
  }

  Future<Requirement> getRequirementById(String id) async {
    Requirement _requirement;

    if ((_requirementList == null) || (_requirementList.length == 0)) {
      await getAllRequirementAcives();
    }

    _requirement = _requirementListById[id];

    if (_requirement == null) {
      _requirement = turnMapInRequirement((await new RequirementDAO()
              .getAllRequirementFilter({'id': id}, {"description": "asc"}))
          .first);
    }

    return _requirement;
  }

  List<Map> getRequirementListWithFilterFromList(Map filter) {
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
    _requirementList.forEach((requirement) {
      _listDocumentSnapshot.add(requirement);
    });

    _listDocumentSnapshotTemp.clear();

    if ((filter["requirementId"] != null) && (filter["requirementId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["documentPath"].toString() ==
            filter["requirementId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["requirementId"] != null) && (filter["requirementId"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    if ((filter["description"] != null) && (filter["description"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["description"].toString().indexOf(filter["description"]) > -1) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["description"] != null) && (filter["description"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    _requirementListWithFilter = _listDocumentSnapshot;

    return _requirementListWithFilter;
  }

  List<Map> getRequirementListWithFilter() {
    return _requirementListWithFilter;
  }

  Requirement turnMapInRequirement(Map map) {
    if (map.isEmpty) {
      return returnEmptyRequirement();
    }

    return new Requirement(
        map["documentPath"], map["description"], map["state"] == "A");
  }

  Requirement returnEmptyRequirement() {
    return new Requirement("", "", false);
  }

  Future<bool> save() async {
    bool saved = true;

    if (_requirement == null) {
      return saved;
    }

    Map<String, dynamic> datas = {
      "description": _requirement.description,
      "state": _requirement.state ? "A" : "I"
    };

    Map<bool, String> result = new Map<bool, String>();

    if (_requirement.id != "") {
      result[await new RequirementDAO().update(_requirement.id, datas) == ""] =
          _requirement.id;
    } else {
      result = await new RequirementDAO().save(datas);
    }

    return saved;
  }
}
