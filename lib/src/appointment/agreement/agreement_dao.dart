import '../base/dao.dart';
import 'agreement_constants.dart';

class AgreementDAO extends DAO {
  AgreementDAO();

  @override
  Future<List<Map>> getAllFilter(
          Map filter, Map orderBy, List comparisons) async =>
      super.getAllFilter(AGREEMENT_COLLECTION, filter, orderBy, comparisons);
}
