class DentistProcedure {
  String _id;
  String _dentistId;
  String _procedureId;

  DentistProcedure( this._id, this._dentistId, this._procedureId);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  String get procedureId => _procedureId;
  set procedureId(String procedureId) => _procedureId = procedureId;
 
}
