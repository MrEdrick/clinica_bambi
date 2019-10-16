import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'dentist_service.dart';

class DentistDAO extends DAO {
  DentistDAO() : super(new Filter(new DentistService().returnEmpty(), null, null));
}
