import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'dentist.dart';
import 'dentist_constants.dart';
import 'dentist_dao.dart';

class DentistService extends Service {
  DentistService() : super() {
    super.dao = new DentistDAO();
    super.orderBy = new OrderBy(DENTIST_FIELD_NAME, ORDER_BY_ASC);
    super.conditionList
      ..clear()
      ..add(new Condition(DENTIST_FIELD_NAME, "", CONDITION_HAS));
  }

  Dentist get dentist => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  Dentist returnEmpty() {
    return new Dentist("", "", "", false);
  }

  Dentist convertMap() {
    return new Dentist(
        super.map[DENTIST_FIELD_ID],
        super.map[DENTIST_FIELD_NAME],
        super.map[DENTIST_FIELD_CODE],
        super.map[DENTIST_FIELD_STATE]);
  }
}
