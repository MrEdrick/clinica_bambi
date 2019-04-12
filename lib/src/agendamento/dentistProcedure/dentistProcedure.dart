import '../dentist/dentist.dart';
import '../procedure/procedure.dart';

class DentistProcedure {
  String _id;
  String _dentistId;
  List<String> _listProcedureId;

  Dentist _dentist;
  List<Procedure> _listProcedure;

  DentistProcedure( this._id, this._dentistId, this._listProcedureId,
                        this._dentist, this._listProcedure);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  List<String> get listProcedureId => _listProcedureId;
  set listProcedureId(List<String> listProcedureId) => _listProcedureId = listProcedureId;

  Dentist get dentist => _dentist;
  set dentist(Dentist dentist) => _dentist = dentist;

  List<Procedure> get listProcedure => _listProcedure;
  set listProcedure(List<Procedure> listProcedure) => _listProcedure = listProcedure;
 
}
