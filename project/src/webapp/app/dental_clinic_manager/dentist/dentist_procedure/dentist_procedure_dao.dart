import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'dentist_procedure_service.dart';

class DentistProcedureDAO extends DAO {
  DentistProcedureDAO() : super(new Filter(new DentistProcedureService().returnEmpty(), null, null));
}
