import 'procedureRequirement.dart';

class ProcedureRequirementService {
  static ProcedureRequirement _procedureRequirement = null;

  ProcedureRequirement get procedureRequirement => _procedureRequirement;
  set procedureRequirement(ProcedureRequirement procedureRequirement) => _procedureRequirement = procedureRequirement;
}