import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'procedure_service.dart';

class ProcedureDAO extends DAO {
  ProcedureDAO()
      : super(new Filter(new ProcedureService().returnEmpty(), null, null));
}
