import '../procedure/procedure.dart';
import '../requirement/requirement.dart';

class ProcedureRequirement {
  String _id;
  String _procedureId;
  List<String> _listRequirementId;

  Procedure _procedure;
  List<Requirement> _listRequirement;

  ProcedureRequirement( this._id, this._procedureId, this._listRequirementId,
                        this._procedure, this._listRequirement);

  String get id => _id;
  set id(String id) => _id = id;

  String get procedureId => _procedureId;
  set procedureId(String procedureId) => _procedureId = procedureId;

  List<String> get listRequirementId => _listRequirementId;
  set listRequirementId(List<String> listRequirementId) => _listRequirementId = listRequirementId;

  Procedure get procedure => _procedure;
  set procedure(Procedure procedure) => _procedure = procedure;

  List<Requirement> get listRequirement => _listRequirement;
  set listRequirement(List<Requirement> listRequirement) => _listRequirement = listRequirement;
 
}
