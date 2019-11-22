import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'patient_account.dart';
import 'patient_account_constants.dart';
import 'patient_account_dao.dart';

class PatientAccountService extends Service {
  PatientAccountService() : super() {
    super.dao = new PatientAccountDAO();
    super.orderBy = new OrderBy(PATIENT_ACCOUNT_FIELD_NAME, ORDER_BY_ASC);
    super.conditionList
      ..clear()
      ..add(new Condition(PATIENT_ACCOUNT_FIELD_NAME, "", CONDITION_HAS));
  }

  PatientAccount get patientAccount => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  PatientAccount returnEmpty() {
    return new PatientAccount("", "", "", "", false);
  }

  PatientAccount convertMap() {
    return new PatientAccount(
        super.map[PATIENT_ACCOUNT_FIELD_ID],
        super.map[PATIENT_ACCOUNT_FIELD_NAME],
        super.map[PATIENT_ACCOUNT_FIELD_EMAIL],
        super.map[PATIENT_ACCOUNT_FIELD_PASSWORD],
        super.map[PATIENT_ACCOUNT_FIELD_STATE]);
  }

  bool emailExists(String email) {
    super.conditionList
      ..clear()
      ..add(new Condition(PATIENT_ACCOUNT_FIELD_EMAIL, email, CONDITION_IS));
    return super.getListWithFilter().isNotEmpty;
  }

  Map getPatiantAccount(String email, String password) {
    super.conditionList
      ..clear()
      ..add(new Condition(PATIENT_ACCOUNT_FIELD_EMAIL, email, CONDITION_IS))
      ..add(new Condition(
          PATIENT_ACCOUNT_FIELD_PASSWORD, password, CONDITION_IS));
    return super.getListWithFilter().first;
  }
}
