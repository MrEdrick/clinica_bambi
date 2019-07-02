import 'dart:async';

import 'auto_appointment_scheduling_constants.dart';
import '../../firebase/firestore.dart';

class AutoAppointmentSchedulingDAO {
  AutoAppointmentSchedulingDAO();

  Future<Map<bool, String>> save(Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(AUTO_APPOINTMENT_SCHEDULING_COLLECTION);

    Map<bool, String> result = (await _fireStoreApp.addItem(datas));
    
    _fireStoreApp.FireStoreOffLine();
    return result;
  }

  Future<String> update(String id, Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(AUTO_APPOINTMENT_SCHEDULING_COLLECTION);

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
        new FireStoreApp(AUTO_APPOINTMENT_SCHEDULING_COLLECTION);
    if (await _fireStoreApp.deleteItem(id)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAllAutoAppointmentSchedulingFilter(Map filter) async {
    bool toAdd;
    List<Map> _list = new List<Map>();
    FireStoreApp fireStoreApp =
        new FireStoreApp(APPOINTMENT_SCHEDULING_COLLECTION);

    await (await fireStoreApp.ref
            .where(filter.keys.first, '==', filter.values.first)
            .get())
        .docs
        .forEach((doc) {
      Map map = new Map.from(doc.data());
      toAdd = true;
      
      filter.forEach((key, value) {
        if (map[key] != value) {
          toAdd = false;
        }
      });

      if (toAdd) {
        map['documentPath'] = doc.id;
        _list.add(map);
      }
    });

    fireStoreApp.FireStoreOffLine();

    return _list;
  }
}
