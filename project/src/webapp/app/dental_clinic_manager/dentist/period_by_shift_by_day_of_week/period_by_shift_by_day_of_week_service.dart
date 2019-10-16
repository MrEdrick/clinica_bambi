import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'period_by_shift_by_day_of_week.dart';
import 'period_by_shift_by_day_of_week_constants.dart';
import 'period_by_shift_by_day_of_week_dao.dart';

class PeriodByShiftByDayOfWeekService extends Service {
  PeriodByShiftByDayOfWeekService() : super() {
    super.dao = new PeriodByShiftByDayOfWeekDAO();
    super.orderBy = null;
    super.conditionList.clear();
  }

  PeriodByShiftByDayOfWeek get dentist => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  PeriodByShiftByDayOfWeek returnEmpty() {
    return new PeriodByShiftByDayOfWeek("", "", "", "", false);
  }

  PeriodByShiftByDayOfWeek convertMap() {
    return new PeriodByShiftByDayOfWeek(
        super.map[PERIOD_BY_SHIFT_BY_DAY_OF_WEEK_FIELD_ID],
        super.map[PERIOD_BY_SHIFT_BY_DAY_OF_WEEK_FIELD_SHIFT_ID],
        super.map[PERIOD_BY_SHIFT_BY_DAY_OF_WEEK_FIELD_DAY_OF_WEEK],
        super.map[PERIOD_BY_SHIFT_BY_DAY_OF_WEEK_FIELD_DESCRIPTION],
        super.map[PERIOD_BY_SHIFT_BY_DAY_OF_WEEK_FIELD_STATE]);
  }
}
