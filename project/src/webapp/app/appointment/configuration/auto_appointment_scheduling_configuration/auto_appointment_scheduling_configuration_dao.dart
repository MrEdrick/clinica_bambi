import 'dart:async';
import 'auto_appointment_scheduling_configuration_constants.dart';
import '../../../firebase/firestore.dart';

class AutoAppointmentSchedulingConfigurationDAO {

  Future<Map<bool, String>> save(Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(AUTO_APPOINTMENT_SCHEDULING_CONFIGURARION_COLLECTION);

    Map<bool, String> result = (await _fireStoreApp.addItem(datas));

    _fireStoreApp.FireStoreOffLine();
    return result;
  }

  Future<String> update(String id, Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(AUTO_APPOINTMENT_SCHEDULING_CONFIGURARION_COLLECTION);

    if (await _fireStoreApp.updateItem(id, datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<String> delete(String id) async {
    FireStoreApp _fireStoreApp = new FireStoreApp(AUTO_APPOINTMENT_SCHEDULING_CONFIGURARION_COLLECTION);
    if (await _fireStoreApp.deleteItem(id)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAllConfigurationFilter(
      Map filter, List comparisons) async {
    List<Map> _list = new List<Map>();
    FireStoreApp _fireStoreApp = new FireStoreApp(AUTO_APPOINTMENT_SCHEDULING_CONFIGURARION_COLLECTION);

    if (filter.length == 0) {
      await (await _fireStoreApp.ref.get()).docs.forEach((doc) {
        Map map = new Map.from(doc.data());
        map['documentPath'] = doc.id;
        _list.add(map);
      });
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

}
