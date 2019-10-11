import '../core/dao/condition.dart';
import '../core/dao/order_by.dart';
import '../core/controller/service.dart';

import 'procedure.dart';
import 'procedure_dao.dart';

class ProcedureService extends Service  {
  ProcedureService() : super() {
    super.dao = new ProcedureDAO();
    super.orderBy = new OrderBy("description", "asc");
    super.conditionList
      ..clear()
      ..add(new Condition("description", "", "has"));
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
    return new Procedure(super.map["documentPath"], super.map["description"],
        super.map["state"]);
  }
}
