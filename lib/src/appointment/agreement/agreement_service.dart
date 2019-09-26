import '../core/dao/condition.dart';
import '../core/dao/order_by.dart';
import '../core/controller/service.dart';

import 'agreement.dart';
import 'agreement_dao.dart';

class AgreementService extends Service {
  static List<Agreement> _list = new List<Agreement>();

  AgreementService() : super() {
    super.dao = new AgreementDAO();
    super.orderBy = new OrderBy("description", "asc");
    super.conditionList
      ..clear()
      ..add(new Condition("description", "", "has"));
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
    return new Agreement(super.map["documentPath"], super.map["description"],
        super.map["state"]);
  }
}
