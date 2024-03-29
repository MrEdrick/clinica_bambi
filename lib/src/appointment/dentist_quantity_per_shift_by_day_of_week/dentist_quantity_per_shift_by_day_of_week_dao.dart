import 'dart:async';

import 'dentist_quantity_per_shift_by_day_of_week_constants.dart';
import '../../firebase/firestore.dart';

class DentistQuantityPerShiftByDayOfWeekDAO {
  DentistQuantityPerShiftByDayOfWeekDAO();

  Future<Map<bool, String>> save(Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(DENTIST_QUANTITY_PER_SHIFT_BY_DAY_OF_WEEK);

    Map<bool, String> result = (await _fireStoreApp.addItem(datas));
    
    _fireStoreApp.FireStoreOffLine();
    return result;
  }

  Future<String> update(String id, Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(DENTIST_QUANTITY_PER_SHIFT_BY_DAY_OF_WEEK);

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
        new FireStoreApp(DENTIST_QUANTITY_PER_SHIFT_BY_DAY_OF_WEEK);
    if (await _fireStoreApp.deleteItem(id)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAllDentistQuantityPerShiftByDayOfWeekFilter(Map filter, List comparisons) async {
    List<Map> _list = new List<Map>();
    FireStoreApp fireStoreApp =
        new FireStoreApp(DENTIST_QUANTITY_PER_SHIFT_BY_DAY_OF_WEEK);

    if (filter.length == 0) {
      await (await fireStoreApp.ref.get()).docs.forEach((doc) {
        Map map = new Map.from(doc.data());
        map['documentPath'] = doc.id;
        _list.add(map);
      });
    } else {
      await (await fireStoreApp.ref
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

    fireStoreApp.FireStoreOffLine();

    return _list;
  }

}
