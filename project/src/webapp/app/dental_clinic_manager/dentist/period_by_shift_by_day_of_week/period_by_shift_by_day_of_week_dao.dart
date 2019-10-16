import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'period_by_shift_by_day_of_week_service.dart';

class PeriodByShiftByDayOfWeekDAO extends DAO {
  PeriodByShiftByDayOfWeekDAO()
      : super(new Filter(
            new PeriodByShiftByDayOfWeekService().returnEmpty(), null, null));
}
