import 'procedure.dart';
import 'procedure_dao.dart';

class ProcedureService {
  static List<Procedure> _list = new List<Procedure>();
  static Procedure _procedure;
  static List<Map> _procedureList = new List<Map>();
  static Map _procedureListById = new Map();
  static List<Map> _procedureListWithFilter = new List<Map>();

  Procedure get procedure => _procedure;
  set procedure(Procedure procedure) => _procedure = procedure;

  void clearAllProcedureList() {
    _list.clear();
    _procedureList.clear();
    _procedureListById.clear();
    _procedureListWithFilter.clear();
  }

  Future<List<Procedure>> getAllProcedureAcives() async {
    if ((_procedureList != null) && (_procedureList.length != 0)) {
      return _list;
    }

    clearAllProcedureList();
    
    await (_procedureList = await new ProcedureDAO()
        .getAllProcedureFilter({"state": "A"}, {"description": "asc"}));
    
    _procedureList.forEach((procedure) {
      _procedureListById[procedure["documentPath"]] = procedure;
      _list.add(turnMapInProcedure(procedure));
    });
    
    return _list;
  }

  Future<Procedure> getProcedureById(String id) async {
    Map doc;

    if ((_procedureList == null) || (_procedureList.length == 0)) {
      await getAllProcedureAcives();
    }

    doc = _procedureListById[id];

    if (doc == null) {
      doc = (await new ProcedureDAO()
              .getAllProcedureFilter({'id': id}, {"description": "asc"}))
          .first;
    }

    return turnMapInProcedure(doc);
  }

  List<Map> getProcedureListWithFilterFromList(Map filter) {
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

    _listDocumentSnapshot = _procedureList;

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

    _procedureListWithFilter = _listDocumentSnapshot;
    
    return _procedureListWithFilter;
  }

  List<Map> getProcedureListWithFilter() {
    return _procedureListWithFilter;
  }


  Procedure turnMapInProcedure(Map map) {
    return new Procedure(
        map["id"], map["description"], map["state"]);
  }
}
