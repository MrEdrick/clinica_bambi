import '../../../core/constants/constants.dart';
import '../../../core/dao/condition.dart';
import '../../../core/dao/order_by.dart';
import '../../../core/controller/service/service.dart';

import 'agreement.dart';
import 'agreement_constants.dart';
import 'agreement_dao.dart';

class AgreementService extends Service {
  AgreementService() : super() {
    super.dao = new AgreementDAO();
    super.orderBy = new OrderBy(AGREEMENT_FIELD_DESCRIPTION, ORDER_BY_ASC);
    super.conditionList
      ..clear()
      ..add(new Condition(AGREEMENT_FIELD_DESCRIPTION, "", CONDITION_HAS));
  }

  Agreement get agreement => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  Agreement returnEmpty() {
    return new Agreement("", "", false);
  }

  Agreement convertMap() {
    return new Agreement(
        super.map[AGREEMENT_FIELD_ID],
        super.map[AGREEMENT_FIELD_DESCRIPTION],
        super.map[AGREEMENT_FIELD_STATE]);
  }
}
