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
}
