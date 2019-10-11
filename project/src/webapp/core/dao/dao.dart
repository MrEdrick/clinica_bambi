import 'dart:async';
import 'package:firebase/firestore.dart';
import '../../database/firebase/firestore.dart';
import 'filter.dart';

class DAO {
  Filter _filter;

  DAO(_filter);

  Filter get filter => _filter;
  set filter(Filter filter) => _filter = filter;

  Future<Map<bool, String>> save() async {
    FireStoreApp _fireStoreApp = new FireStoreApp(_filter.collection.description);

    Map<bool, String> result =
        (await _fireStoreApp.addItem(_filter.collection.fieldMap));

    _fireStoreApp.FireStoreOffLine();
    return result;
  }

  Future<String> update() async {
    FireStoreApp _fireStoreApp = new FireStoreApp(_filter.collection.description);
    if (await _fireStoreApp.updateItem(_filter.collection.id, _filter.collection.fieldMap)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<String> delete() async {
    FireStoreApp _fireStoreApp = new FireStoreApp(_filter.collection.description);
    if (await _fireStoreApp.deleteItem(_filter.collection.id)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAll() async {
    List<Map> _list = new List<Map>();
    FireStoreApp _fireStoreApp = new FireStoreApp(_filter.collection.description);

    await (await _fireStoreApp.ref.get()).docs.forEach((doc) {
      Map map = new Map.from(doc.data());
      map['documentPath'] = doc.id;
      _list.add(map);
    });

    _fireStoreApp.FireStoreOffLine();

    return _list;
  }

  Future<List<Map>> getAllFilter() async {
    List<Map> _list = new List<Map>();
    FireStoreApp _fireStoreApp =
        new FireStoreApp(_filter.collection.description);

    if (_filter.conditionList.length == 0) {
      _list = await getAll();
    } else {
      await (await _fireStoreApp.ref
              .where(
                  _filter.conditionList.first.field.toString(),
                  _filter.conditionList.first.comparation.toString(),
                  _filter.conditionList.first.value.toString())
              .get())
          .docs
          .forEach((doc) {
        Map map = new Map.from(doc.data());
        map['documentPath'] = doc.id;
        _list.add(map);
      });
    }

    _fireStoreApp.FireStoreOffLine();

    return _list;
  }

  Future<Map> getOneFilter(Filter filter) async {
    Map map = new Map();
    FireStoreApp _fireStoreApp =
        new FireStoreApp(filter.collection.description);

    DocumentSnapshot doc = (await _fireStoreApp.ref
            .where(
                filter.conditionList.first.field.toString(),
                filter.conditionList.first.comparation.toString(),
                filter.conditionList.first.value.toString())
            .limit(1)
            .get())
        .docs
        .first;

    map = Map.from(doc.data());
    map['documentPath'] = doc.id;

    _fireStoreApp.FireStoreOffLine();

    return map;
  }
}