import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'agreement_service.dart';

class AgreementDAO extends DAO {
  AgreementDAO()
      : super(new Filter(new AgreementService().returnEmpty(), null, null));
}
