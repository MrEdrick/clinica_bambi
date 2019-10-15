import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'shift.dart';
import 'shift_constants.dart';
import 'shift_dao.dart';

class ShiftService extends Service {
  ShiftService() : super() {
    super.dao = new ShiftDAO();
    super.orderBy = new OrderBy(SHIFT_FIELD_DESCRIPTION, ORDER_BY_ASC);
    super.conditionList
      ..clear()
      ..add(new Condition(SHIFT_FIELD_DESCRIPTION, "", CONDITION_HAS));
  }

  Shift get agreement => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  Shift returnEmpty() {
    return new Shift("", "", "", 0, false);
  }

  Shift convertMap() {
    return new Shift(
        super.map[SHIFT_FIELD_ID],
        super.map[SHIFT_FIELD_DESCRIPTION],
        super.map[SHIFT_FIELD_OBSERVATION],
        super.map[SHIFT_FIELD_START_TIME],
        super.map[SHIFT_FIELD_STATE]);
  }
}
