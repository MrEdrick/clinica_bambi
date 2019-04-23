import 'dentist_procedure.dart';
import 'dentist_procedure_dao.dart';

class DentistProcedureService {
  static DentistProcedure _dentistProcedure;
  static List<DentistProcedure> _list = new List<DentistProcedure>();
  static List<Map> _dentistProcedureList = new List<Map>();
  static Map _dentistProcedureListById = new Map();
  static List<Map> _dentistProcedureListWithFilter = new List<Map>();


  DentistProcedure get dentistProcedure => _dentistProcedure;
  set dentistProcedure(DentistProcedure dentistProcedure) =>
      _dentistProcedure = dentistProcedure;

  void clearAllDentistProcedureList() {
    _list.clear();
    _dentistProcedureList.clear();
    _dentistProcedureListById.clear();
    _dentistProcedureListWithFilter.clear();
  }

  Future<List<DentistProcedure>> getAllDentistProcedureAcives() async {
    if ((_dentistProcedureList != null) && (_dentistProcedureList.length != 0)) {
      return _list;
    }

    clearAllDentistProcedureList();
    
    await (_dentistProcedureList = await new DentistProcedureDAO()
        .getAllDentistProcedureFilter({"dentistProcedureId": ""}, [">="]));
    
    _dentistProcedureList.forEach((dentistProcedure) {
      _dentistProcedureListById[dentistProcedure["documentPath"]] = dentistProcedure;
      _list.add(turnMapInDentistProcedure(dentistProcedure));
    });
    
    return _list;
  }

  Future<DentistProcedure> getOneDentistProcedureByFilter(Map filter) async {
    Map doc;

    if ((_dentistProcedureList == null) || (_dentistProcedureList.length == 0)) {
      await getAllDentistProcedureAcives();
    }

    doc = getDentistProcedureListWithFilterFromList(filter).first;

    if (doc == null) {
      doc = (await new DentistProcedureDAO()
              .getAllDentistProcedureFilter(filter, ["=="]))
          .first;
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
    }

    ListsApplyFilter();

    if ((filter["procedureId"] != null) && (filter["procedureId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["procedureId"].toString() == filter["procedureId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["procedureId"] != null) && (filter["procedureId"] != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    _dentistProcedureListWithFilter = _listDocumentSnapshot;
    
    return _dentistProcedureListWithFilter;
  }


  DentistProcedure turnMapInDentistProcedure(Map map) {
    return new DentistProcedure(map["documentPath"], map["dentistId"], map["procedureId"]);
  }

}
