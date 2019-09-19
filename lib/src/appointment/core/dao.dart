import 'dart:async';
import 'package:firebase/firestore.dart';
import '../../firebase/firestore.dart';
import 'filter.dart';
import 'collection.dart';

class DAO {
  Future<Map<bool, String>> save(Collection collection) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(collection.description);

    Map<bool, String> result = (await _fireStoreApp.addItem(
        new Map<String, dynamic>.fromIterable(collection.fieldList
            .map((field) => [field.description, field.value]))));

    _fireStoreApp.FireStoreOffLine();
    return result;
  }

  Future<String> update(
      String collection, String id, Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(collection);

    if (await _fireStoreApp.updateItem(id, datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<String> delete(String collection, String id) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(collection);
    if (await _fireStoreApp.deleteItem(id)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAll(String collection, List comparisons) async {
    List<Map> _list = new List<Map>();
    FireStoreApp _fireStoreApp = new FireStoreApp(collection);

    await (await _fireStoreApp.ref.get()).docs.forEach((doc) {
      Map map = new Map.from(doc.data());
      map['documentPath'] = doc.id;
      _list.add(map);
    });

    _fireStoreApp.FireStoreOffLine();

    return _list;
  }

  Future<List<Map>> getAllFilter(
      String collection, Map filter, Map orderBy, List comparisons) async {
    List<Map> _list = new List<Map>();
    FireStoreApp _fireStoreApp = new FireStoreApp(collection);

    if (filter.length == 0) {
      _list = await getAll(collection, comparisons);
    } else {
      await (await _fireStoreApp.ref
              .where(filter.keys.first.toString(), comparisons.first.toString(),
                  filter.values.first.toString())
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

  Future<Map> getOneFilter(
      String collection, Map filter, List comparisons) async {
    Map map = new Map();
    FireStoreApp _fireStoreApp = new FireStoreApp(collection);

    DocumentSnapshot doc = (await _fireStoreApp.ref
            .where(filter.keys.first.toString(), comparisons.first.toString(),
                filter.values.first.toString())
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
