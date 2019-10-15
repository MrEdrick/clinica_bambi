import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'patient_account_service.dart';

class PatientAccountDAO extends DAO {
  PatientAccountDAO()
      : super(
            new Filter(new PatientAccountService().returnEmpty(), null, null));
}
