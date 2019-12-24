import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';

import '../../../../core/controller/service/service.dart';
import 'dentist_quantity_per_shift_by_day_of_week.dart';
import 'dentist_quantity_per_shift_by_day_of_week_constants.dart';
import 'dentist_quantity_per_shift_by_day_of_week_dao.dart';

class DentistQuantityPerShiftByDayOfWeekService extends Service {
  DentistQuantityPerShiftByDayOfWeekService() : super() {
    super.dao = new DentistQuantityPerShiftByDayOfWeekDAO();
    super.orderBy = null;
    super.conditionList.clear();
  }

  DentistQuantityPerShiftByDayOfWeek get dentistQuantityPerShiftByDayOfWeek =>
      convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  DentistQuantityPerShiftByDayOfWeek returnEmpty() {
    return new DentistQuantityPerShiftByDayOfWeek("", "", "", "", 0);
  }

  DentistQuantityPerShiftByDayOfWeek convertMap() {
    return new DentistQuantityPerShiftByDayOfWeek(
        super.map[DENTIST_QUANTITY_PER_SHIFT_BY_DAY_OF_WEEK_FIELD_ID],
        super.map[DENTIST_QUANTITY_PER_SHIFT_BY_DAY_OF_WEEK_FIELD_DAY_OF_WEEK],
        super.map[DENTIST_QUANTITY_PER_SHIFT_BY_DAY_OF_WEEK_FIELD_DENTIST_ID],
        super.map[DENTIST_QUANTITY_PER_SHIFT_BY_DAY_OF_WEEK_FIELD_SHIFT_ID],
        super.map[DENTIST_QUANTITY_PER_SHIFT_BY_DAY_OF_WEEK_FIELD_QUANTITY]);
  }
}