import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'procedure_requirement_service.dart';

class ProcedureRquirementDAO extends DAO {
  ProcedureRquirementDAO()
      : super(new Filter(new ProcedureRequirementService().returnEmpty(), null, null));
}
