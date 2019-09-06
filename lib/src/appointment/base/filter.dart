import 'collection.dart';

class Filter {
  Collection _collection;
  Map<String, List<String>> _fieldValueCompationMap;
  Map<String, String> _orderBy;

  Filter(this._collection, this._fieldValueCompationMap, this._orderBy);

  Collection get collection => _collection;
  set collection(Collection collection) => _collection = collection;

  Map<String, List<String>> get fieldValueCompationMap =>
      _fieldValueCompationMap;
  set fieldValueCompationMap(
          Map<String, List<String>> fieldValueCompationMap) =>
      _fieldValueCompationMap = fieldValueCompationMap;

  Map<String, String> get orderBy => _orderBy;
  set orderBy(Map<String, String> orderBy) => _orderBy = orderBy;
}
