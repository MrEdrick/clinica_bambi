import 'dart:async';
import 'dentist.dart';
import 'dentistUI.dart';
import '../../firebase/firestore.dart';

class DentistService {
  static List<Dentist> _list;
  static Dentist _dentist;

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

  Future<List<DentistUI>> getAllDentistUIAcives() async {
    List<Dentist> _listDentist = await getAllDentistAcives();
    List<DentistUI> _listDentistUI = new List<DentistUI>();
    
    for (Dentist _detist in _listDentist) {
      _listDentistUI.add(new DentistUI(_detist.id, _detist.name, _detist.state));
    }

    return _listDentistUI;
  }

  Future<Dentist> getDentistById(String id) async {
    if (_list == null) {
      print("teste");
      await getAllDentistAcives();
    }

    for (var i = 0; i < _list.length; i++) {
      if (_list[i].id == id) {
        return _list[i];
      }
    };

     return null;
  }

  Dentist get dentist => _dentist;
  set dentist(Dentist dentist) => _dentist = dentist;

}