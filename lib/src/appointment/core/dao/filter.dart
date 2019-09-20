import 'collection.dart';
import 'condition.dart';

class Filter {
  Collection _collection;
  List<Condition> _conditionList;
  Map<String, String> _orderBy;

  Filter(this._collection, this._conditionList, this._orderBy);

  Collection get collection => _collection;
  set collection(Collection collection) => _collection = collection;

  List<Condition> get conditionList =>
      _conditionList;
  set conditionList(
          List<Condition> conditionList) =>
      _conditionList = conditionList;

  Map<String, String> get orderBy => _orderBy;
  set orderBy(Map<String, String> orderBy) => _orderBy = orderBy;
}
