import 'dart:async';
import 'dentist.dart';
import '../../firebase/firestore.dart';

class DentistService {
  static List<Dentist> _list;

  Future<List<Dentist>> getAllDentistAcives() async {
    if (_list != null) {
      return _list;
    }

    FireStoreApp fireStoreApp = new FireStoreApp('dentist');

    await fireStoreApp.ref
      .where('state', '==', 'A')
      .orderBy('name', 'asc')
      .get().then((querySnapshot) {
        int i = 0;
        _list = new List<Dentist>(querySnapshot.size);
        querySnapshot.forEach((doc) {
          _list[i] = new Dentist(doc.id, doc.data()["name"], doc.data()["state"]);
          i++;
        });
      }).then((onValue) {
        fireStoreApp.FireStoreOffLine();
      });

    return _list;
  }

  Future<Dentist> getDentistById(String id) async {
    if (_list == null) {
      await getAllDentistAcives();
    }

    for (var i = 0; i < _list.length; i++) {
      if (_list[i].id == id) {
        return _list[i];
      }
    };

     return null;
  }

}