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

  Future<DentistProcedure> getDentistProcedureByFilter(Map filter) async {
    Map doc;

    if ((_dentistProcedureList == null) || (_dentistProcedureList.length == 0)) {
      await getAllDentistProcedureAcives();
    }

    doc = _dentistListById[id];

    if (doc == null) {
      doc = (await new DentistProcedureDAO()
              .getAllDentistProcedureFilter(filter, ["=="]))
          .first;
    }

    return turnMapInDentistProcedure(doc);
  }

  DentistProcedure turnMapInDentistProcedure(Map map) {
    return new DentistProcedure(map["documentPath"], map["dentistId"], map["procedureId"]);
  }

}
