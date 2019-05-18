import 'requirement.dart';
import 'requirement_dao.dart';

class RequirementService {
  static List<Requirement> _list = new List<Requirement>();
  static Requirement _requirement;
  static List<Map> _requirementList = new List<Map>();
  static Map _requirementListById = new Map();
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
      _requirementListById[requirement["documentPath"]] = turnMapInRequirement(requirement);
      
      _list.add(turnMapInRequirement(requirement));
    });
    
    return _list;
  }


  Future<Requirement> getRequirementById(String id) async {
    Map doc;

    if ((_requirementList == null) || (_requirementList.length == 0)) {
      await getAllRequirementAcives();
    }

    doc = _requirementListById[id];

    if (doc == null) {
      doc = (await new RequirementDAO()
              .getAllRequirementFilter({'id': id}, {"description": "asc"}))
          .first;
    }

    return turnMapInRequirement(doc);
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

    _listDocumentSnapshot = _requirementList;

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

    _requirementListWithFilter = _listDocumentSnapshot;
    
    return _requirementListWithFilter;
  }

  List<Map> getRequirementListWithFilter() {
    return _requirementListWithFilter;
  }

  Requirement turnMapInRequirement(Map map) {
    return new Requirement(map["documentPath"], map["description"], map["state"]);
  }
}