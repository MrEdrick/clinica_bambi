import 'dart:async';

import 'appointment_scheduling_constants.dart';
import 'consulta.dart';
import '../shift/shift_service.dart';
import '../agreement/agreement_service.dart';
import '../dentist/dentist_service.dart';
import '../../firebase/firestore.dart';

class AppointmentSchedulingDAO {
  AppointmentSchedulingDAO();

  Future<String> save(Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(APPOINTMENT_SCHEDULING_COLLECTION);

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
        new FireStoreApp(APPOINTMENT_SCHEDULING_COLLECTION);

    if (await _fireStoreApp.updateItem(id, datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<DocumentSnapshot>> getAllAppointmentSchedulingFilter(Map filter) async {
    int i = 0;
    List<DocumentSnapshot> _list;
    FireStoreApp fireStoreApp =
        new FireStoreApp(APPOINTMENT_SCHEDULING_COLLECTION);

    await fireStoreApp.ref
        .where(filter.keys.first, '==', filter.values.first)
        .get()
        .then((querySnapshot) {
      _list = querySnapshot;
    }).then((onValue) {
      fireStoreApp.FireStoreOffLine();
    });

    return _list;
  }
}
