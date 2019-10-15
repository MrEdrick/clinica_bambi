import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'shift_service.dart';

class ShiftDAO extends DAO {
  ShiftDAO() : super(new Filter(new ShiftService().returnEmpty(), null, null));
}
