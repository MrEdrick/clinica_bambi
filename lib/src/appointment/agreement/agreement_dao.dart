import '../core/dao/dao.dart';
import '../core/dao/filter.dart';
import 'agreement.dart';

class AgreementDAO extends DAO {
  AgreementDAO() : super(new Filter(new Agreement("", "", false), null, null));
}
