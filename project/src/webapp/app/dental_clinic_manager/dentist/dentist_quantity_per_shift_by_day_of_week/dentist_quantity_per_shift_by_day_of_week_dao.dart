import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'dentist_quantity_per_shift_by_day_of_week_service.dart';

class DentistQuantityPerShiftByDayOfWeekDAO extends DAO {
  DentistQuantityPerShiftByDayOfWeekDAO()
      : super(new Filter(
            new DentistQuantityPerShiftByDayOfWeekService().returnEmpty(),
            null,
            null));
}
