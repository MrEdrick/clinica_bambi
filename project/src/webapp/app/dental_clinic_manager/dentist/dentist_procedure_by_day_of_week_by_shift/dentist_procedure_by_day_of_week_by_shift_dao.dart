import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'dentist_procedure_by_day_of_week_by_shift_service.dart';

class DentistProcedureByDayOfWeekByShiftDAO extends DAO {
  DentistProcedureByDayOfWeekByShiftDAO()
      : super(new Filter(
            new DentistProcedureByDayOfWeekByShiftService().returnEmpty(),
            null,
            null));
}
