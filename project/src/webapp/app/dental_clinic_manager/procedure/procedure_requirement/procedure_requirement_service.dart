import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'procedure_requirement.dart';
import 'procedure_requirement_constants.dart';
import 'procedure_requirement_dao.dart';

class ProcedureRequirementService extends Service {
  ProcedureRequirementService() : super() {
    super.dao = new ProcedureRquirementDAO();
    super.orderBy = null;
    super.conditionList.clear();
  }

  ProcedureRequirement get procedureRequirement => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  ProcedureRequirement returnEmpty() {
    return new ProcedureRequirement("", "", "");
  }

  ProcedureRequirement convertMap() {
    return new ProcedureRequirement(
        super.map[PROCEDURE_REQUIREMENT_FIELD_ID],
        super.map[PROCEDURE_REQUIREMENT_FIELD_PROCEDURE_ID],
        super.map[PROCEDURE_REQUIREMENT_FIELD_REQUIREMENT_ID]);
  }
}
