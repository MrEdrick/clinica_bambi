class ProcedureRequirement {
  String _id;
  String _procedureId;
  String _requirementId;

  ProcedureRequirement( this._id, this._procedureId, this._requirementId);

  String get id => _id;
  set id(String id) => _id = id;

  String get procedureId => _procedureId;
  set procedureId(String procedureId) => _procedureId = procedureId;

  String get requirementId => _requirementId;
  set requirementId(String requirementId) => _requirementId = requirementId;
 
}
