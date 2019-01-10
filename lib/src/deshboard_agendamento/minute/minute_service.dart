import 'dart:async';
import 'minute.dart';
import '../../firebase/firestore.dart';

class MinuteService {
  static List<Minute> _list;

  Future<List<Minute>> getAllMinuteAcives() async {
    if (_list != null) {
      return _list;
    }

    FireStoreApp fireStoreApp = new FireStoreApp('minute');

    await fireStoreApp.ref
      .where('state', '==', 'A')
      .orderBy('description', 'asc')
      .get().then((querySnapshot) {
        int i = 0;
        _list = new List<Minute>(querySnapshot.size);
        querySnapshot.forEach((doc) {
          _list[i] = new Minute(doc.id, doc.data()["description"], doc.data()["state"]);
          i++;
        });
      }).then((onValue) {
        fireStoreApp.FireStoreOffLine();
      });

    return _list;
  }

  Future<Minute> getMinuteById(String minuteId) async {
    if (_list == null) {
      await getAllMinuteAcives();
    }

    for (var i = 0; i < _list.length; i++) {
      if (_list[i].minuteId == minuteId) {
        return _list[i];
      }
    };

     return null;
  }

}