import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'dentist_procedure.dart';
import 'dentist_procedure_constants.dart';
import 'dentist_procedure_dao.dart';

class DentistProcedureService extends Service {
  DentistProcedureService() : super() {
    super.dao = new DentistProcedureDAO();
    super.orderBy = null;
    super.conditionList.clear();
  }

  DentistProcedure get dentistProcedure => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  DentistProcedure returnEmpty() {
    return new DentistProcedure("", "", "");
  }

  DentistProcedure convertMap() {
    return new DentistProcedure(
        super.map[DENTIST_PROCEDURE_FIELD_ID],
        super.map[DENTIST_PROCEDURE_FIELD_DENTIST_ID],
        super.map[DENTIST_PROCEDURE_FIELD_PROCEDURE_ID]);
  }
}
