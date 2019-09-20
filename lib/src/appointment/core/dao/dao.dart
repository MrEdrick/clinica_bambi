import 'dart:async';
import 'package:firebase/firestore.dart';
import '../../../firebase/firestore.dart';
import 'filter.dart';
import 'collection.dart';

class DAO {
  Future<Map<bool, String>> save(Collection collection) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(collection.description);

    Map<bool, String> result =
        (await _fireStoreApp.addItem(collection.fieldMap));

    _fireStoreApp.FireStoreOffLine();
    return result;
  }

  Future<String> update(Collection collection) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(collection.description);
    if (await _fireStoreApp.updateItem(collection.id, collection.fieldMap)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<String> delete(Collection collection) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(collection.description);
    if (await _fireStoreApp.deleteItem(collection.id)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAll(Collection collection) async {
    List<Map> _list = new List<Map>();
    FireStoreApp _fireStoreApp = new FireStoreApp(collection.description);

    await (await _fireStoreApp.ref.get()).docs.forEach((doc) {
      Map map = new Map.from(doc.data());
      map['documentPath'] = doc.id;
      _list.add(map);
    });

    _fireStoreApp.FireStoreOffLine();

    return _list;
  }

  Future<List<Map>> getAllFilter(Filter filter) async {
    List<Map> _list = new List<Map>();
    FireStoreApp _fireStoreApp =
        new FireStoreApp(filter.collection.description);

    if (filter.conditionList.length == 0) {
      _list = await getAll(filter.collection);
    } else {
      await (await _fireStoreApp.ref
              .where(
                  filter.conditionList.first.field.toString(),
                  filter.conditionList.first.comparation.toString(),
                  filter.conditionList.first.value.toString())
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
