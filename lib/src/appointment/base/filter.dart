import 'collection.dart';

class Filter {
  Collection _collection;

  Filter(this._collection);

  Collection get collection => _collection;
  set collection(Collection collection) => _collection = collection;

}