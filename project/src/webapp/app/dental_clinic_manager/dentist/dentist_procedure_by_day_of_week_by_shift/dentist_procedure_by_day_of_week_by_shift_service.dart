import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'dentist_procedure_by_day_of_week_by_shift.dart';
import 'dentist_procedure_by_day_of_week_by_shift_constants.dart';
import 'dentist_procedure_by_day_of_week_by_shift_dao.dart';

class DentistProcedureByDayOfWeekByShiftService extends Service {
  DentistProcedureByDayOfWeekByShiftService() : super() {
    super.dao = new DentistProcedureByDayOfWeekByShiftDAO();
    super.orderBy = null;
    super.conditionList.clear();
  }

  DentistProcedureByDayOfWeekByShift get dentistProcedureByDayOfWeek =>
      convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  DentistProcedureByDayOfWeekByShift returnEmpty() {
    return new DentistProcedureByDayOfWeekByShift("", "", "");
  }

  DentistProcedureByDayOfWeekByShift convertMap() {
    return new DentistProcedureByDayOfWeekByShift(
        super.map[DENTIST_PROCEDURE_BY_DAY_OF_WEEK_BY_SHIFT_FIELD_ID],
        super.map[
            DENTIST_PROCEDURE_BY_DAY_OF_WEEK_BY_SHIFT_FIELD_DENTIST_PROCEDURE_BY_DAY_OF_WEEK_ID],
        super.map[DENTIST_PROCEDURE_BY_DAY_OF_WEEK_BY_SHIFT_FIELD_SHIFT_ID]);
  }
}
