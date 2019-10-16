import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'dentist_procedure_by_day_of_week.dart';
import 'dentist_procedure_by_day_of_week_constants.dart';
import 'dentist_procedure_by_day_of_week_dao.dart';

class DentistProcedureByDayOfWeekService extends Service {
  DentistProcedureByDayOfWeekService() : super() {
    super.dao = new DentistProcedureByDayOfWeekDAO();
    super.orderBy = null;
    super.conditionList.clear();
  }

  DentistProcedureByDayOfWeek get dentistProcedureByDayOfWeek => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  DentistProcedureByDayOfWeek returnEmpty() {
    return new DentistProcedureByDayOfWeek("", "", "");
  }

  DentistProcedureByDayOfWeek convertMap() {
    return new DentistProcedureByDayOfWeek(
        super.map[DENTIST_PROCEDURE_BY_DAY_OF_WEEK_FIELD_ID],
        super.map[DENTIST_PROCEDURE_BY_DAY_OF_WEEK_FIELD_DENTIST_PROCEDURE_ID],
        super.map[DENTIST_PROCEDURE_BY_DAY_OF_WEEK_FIELD_DAY_OF_WEEK]);
  }
}
