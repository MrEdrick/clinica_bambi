import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'requirement.dart';
import 'requirement_constants.dart';
import 'requirement_dao.dart';

class RequirementService extends Service {
  RequirementService() : super() {
    super.dao = new RequirementDAO();
    super.orderBy = new OrderBy(REQUIREMENT_FIELD_DESCRIPTION, ORDER_BY_ASC);
    super.conditionList
      ..clear()
      ..add(new Condition(REQUIREMENT_FIELD_DESCRIPTION, "", CONDITION_HAS));
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
    return new Requirement(
        super.map[REQUIREMENT_FIELD_ID],
        super.map[REQUIREMENT_FIELD_DESCRIPTION],
        super.map[REQUIREMENT_FIELD_STATE]);
  }
}
