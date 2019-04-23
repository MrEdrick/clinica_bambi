class DentistProcedureByDayOfWeekByShift {
  String _id;
  String _dentistProcedureByDayOfWeekId;
  String _shiftId;

  DentistProcedureByDayOfWeekByShift(
      this._id, this._dentistProcedureByDayOfWeekId, this._shiftId);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistProcedureByDayOfWeekId => _dentistProcedureByDayOfWeekId;
  set dentistProcedureByDayOfWeekId(String dentistProcedureByDayOfWeekId) =>
      _dentistProcedureByDayOfWeekId = dentistProcedureByDayOfWeekId;

  String get shiftId => _shiftId;
  set shiftId(String shiftId) => _shiftId = shiftId;
}
