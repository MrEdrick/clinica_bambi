import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'dentist_procedure_by_day_of_week_service.dart';

class DentistProcedureByDayOfWeekDAO extends DAO {
  DentistProcedureByDayOfWeekDAO()
      : super(new Filter(new DentistProcedureByDayOfWeekService().returnEmpty(),
            null, null));
}
