import 'dentist_procedure.dart';
import 'dentist_procedure_dao.dart';

class DentistProcedureService {
  static DentistProcedure _dentistProcedure = null;

  DentistProcedure get dentistProcedure => _dentistProcedure;
  set dentistProcedure(DentistProcedure dentistProcedure) =>
      _dentistProcedure = dentistProcedure;

  Future<DentistProcedure> getDentistProcedureByFilter(Map filter) async {
    Map doc;

    if ((_dentistList == null) || (_dentistList.length == 0)) {
      await getAllDentistAcives();
    }

    doc = _dentistListById[id];

    if (doc == null) {
      doc = (await new DentistProcedureDAO()
              .getAllDentistProcedureFilter(filter))
          .first;
    }

    return turnMapInDentistProcedure(doc);
  }

  DentistProcedure turnMapInDentistProcedure(Map map) {
    return new DentistProcedure(map["documentPath"], map["dentistId"], map["procedureId"]);
  }

}
