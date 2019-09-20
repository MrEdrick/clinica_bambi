import 'collection.dart';
import 'condition.dart';
import 'order_by.dart';

class Filter {
  Collection _collection;
  List<Condition> _conditionList;
  OrderBy _orderBy;

  Filter(this._collection, this._conditionList, this._orderBy);

  Collection get collection => _collection;
  set collection(Collection collection) => _collection = collection;

  List<Condition> get conditionList =>
      _conditionList;
  set conditionList(
          List<Condition> conditionList) =>
      _conditionList = conditionList;

  OrderBy get orderBy => _orderBy;
  set orderBy(OrderBy orderBy) => _orderBy = orderBy;
}
