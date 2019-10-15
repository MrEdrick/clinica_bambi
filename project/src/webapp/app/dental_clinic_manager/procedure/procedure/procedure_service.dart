import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'procedure.dart';
import 'procedure_constants.dart';
import 'procedure_dao.dart';

class ProcedureService extends Service {
  ProcedureService() : super() {
    super.dao = new ProcedureDAO();
    super.orderBy = new OrderBy(PROCEDURE_FIELD_DESCRIPTION, ORDER_BY_ASC);
    super.conditionList
      ..clear()
      ..add(new Condition(PROCEDURE_FIELD_DESCRIPTION, "", CONDITION_HAS));
  }

  Procedure get procedure => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  Procedure returnEmpty() {
    return new Procedure("", "", false);
  }

  Procedure convertMap() {
    return new Procedure(
        super.map[PROCEDURE_FIELD_ID],
        super.map[PROCEDURE_FIELD_DESCRIPTION],
        super.map[PROCEDURE_FIELD_STATE]);
  }
}
