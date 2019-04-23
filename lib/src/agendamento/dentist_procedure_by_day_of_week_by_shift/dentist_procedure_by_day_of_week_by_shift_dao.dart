import 'dart:async';

import 'dentist_procedure_by_day_of_week_by_shift_constants.dart';
import '../../firebase/firestore.dart';

class DentistProcedureByDayOfWeekByShiftDAO {
  DentistProcedureByDayOfWeekByShiftDAO();

  Future<Map<bool, String>> save(Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(DENTIST_PROCEDURE_BY_DAY_OF_WEEK_BY_SHIFT_COLLECTION);

    Map<bool, String> result = (await _fireStoreApp.addItem(datas));
    
    _fireStoreApp.FireStoreOffLine();
    return result;
  }

  Future<String> update(String id, Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(DENTIST_PROCEDURE_BY_DAY_OF_WEEK_BY_SHIFT_COLLECTION);

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
        new FireStoreApp(DENTIST_PROCEDURE_BY_DAY_OF_WEEK_BY_SHIFT_COLLECTION);
    if (await _fireStoreApp.deleteItem(id)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAllDentistProcedureByDayOfWeekByShiftFilter(Map filter, List comparisons) async {
    List<Map> _list = new List<Map>();
    FireStoreApp fireStoreApp =
        new FireStoreApp(DENTIST_PROCEDURE_BY_DAY_OF_WEEK_BY_SHIFT_COLLECTION);

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
