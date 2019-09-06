class DentistProcedureByDayOfWeek {
  String _id;
  String _dentistProcedureId;
  String _dayOfWeek;

  DentistProcedureByDayOfWeek( this._id, this._dentistProcedureId, this._dayOfWeek);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistProcedureId => _dentistProcedureId;
  set dentistProcedureId(String dentistProcedureId) => _dentistProcedureId = dentistProcedureId;

  String get dayOfWeek => _dayOfWeek;
  set dayOfWeek(String dayOfWeek) => _dayOfWeek = dayOfWeek;
}
