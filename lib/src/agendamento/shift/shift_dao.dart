import 'dart:async';

import 'shift_constants.dart';
import '../../firebase/firestore.dart';

class ShiftDAO {
  ShiftDAO();

  Future<String> save(Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(SHIFT_COLLECTION);

    if (await _fireStoreApp.addItem(datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<String> update(String id, Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(SHIFT_COLLECTION);

    if (await _fireStoreApp.updateItem(id, datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<String> delete(String id) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(SHIFT_COLLECTION);
    if (await _fireStoreApp.deleteItem(id)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAllShiftFilter(Map filter, Map orderBy) async {
    List<Map> _list = new List<Map>();
    FireStoreApp fireStoreApp =
        new FireStoreApp(SHIFT_COLLECTION);

    await (await fireStoreApp.ref
            .where(filter.keys.first, '==', filter.values.first)
            .orderBy(orderBy.keys.first, orderBy.values.first)
            .get())
        .docs
        .forEach((doc) {
      Map map = new Map.from(doc.data());
      map['documentPath'] = doc.id;
      _list.add(map);
    });

    fireStoreApp.FireStoreOffLine();

    return _list;
  }
}
