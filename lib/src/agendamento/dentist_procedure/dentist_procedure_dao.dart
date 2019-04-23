import 'dart:async';

import 'dentist_procedure_constants.dart';
import '../../firebase/firestore.dart';

class DentistProcedureDAO {
  DentistProcedureDAO();

  Future<Map<bool, String>> save(Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(DENTIST_PROCEDURE_COLLECTION);

    Map<bool, String> result = (await _fireStoreApp.addItem(datas));
    
    _fireStoreApp.FireStoreOffLine();
    return result;
  }

  Future<String> update(String id, Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(DENTIST_PROCEDURE_COLLECTION);

    if (await _fireStoreApp.updateItem(id, datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAllDentistProcedureFilter(Map filter, List comparisons) async {
    List<Map> _list = new List<Map>();
    FireStoreApp fireStoreApp =
        new FireStoreApp(DENTIST_PROCEDURE_COLLECTION);

    await (await fireStoreApp.ref
            .where(filter.keys.first, comparisons.first, filter.values.first)
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
