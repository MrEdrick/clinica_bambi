import '../core/dao/condition.dart';
import '../core/dao/order_by.dart';
import '../core/controller/service.dart';

import 'requirement.dart';
import 'requirement_dao.dart';

class RequirementService extends Service {
  RequirementService() : super() {
    super.dao = new RequirementDAO();
    super.orderBy = new OrderBy("description", "asc");
    super.conditionList
      ..clear()
      ..add(new Condition("description", "", "has"));
  }

  Requirement get requirement => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  Requirement returnEmpty() {
    return new Requirement("", "", false);
  }

  Requirement convertMap() {
    return new Requirement(super.map["documentPath"], super.map["description"],
        super.map["state"]);
  }
}
