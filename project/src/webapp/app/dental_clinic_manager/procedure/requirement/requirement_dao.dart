import '../../../core/dao/dao.dart';
import '../../../core/dao/filter.dart';
import 'requirement_service.dart';

class RequirementDAO extends DAO {
  RequirementDAO()
      : super(new Filter(new RequirementService().returnEmpty(), null, null));
}
