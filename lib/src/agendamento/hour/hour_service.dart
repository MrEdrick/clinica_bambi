import 'dart:async';
import 'hour.dart';
import '../../firebase/firestore.dart';

class HourService {
  static List<Hour> _list;

  Future<List<Hour>> getAllHourAcives() async {
    if (_list != null) {
      return _list;
    }
    
    FireStoreApp fireStoreApp = new FireStoreApp('hour');

    await fireStoreApp.ref
      .where('state', '==', 'A')
      .orderBy('description', 'asc')
      .get().then((querySnapshot) {
        int i = 0;
        _list = new List<Hour>(querySnapshot.size);
        querySnapshot.forEach((doc) {
          _list[i] = new Hour(doc.id, doc.data()["description"], doc.data()["state"]);
          i++;
        });
      }).then((onValue) {
        fireStoreApp.FireStoreOffLine();
      });

    return _list;
  }

  Future<Hour> getHourById(String hourId) async {
    if (_list == null) {
      await getAllHourAcives();
    }

    for (var i = 0; i < _list.length; i++) {
      if (_list[i].hourId == hourId) {
        return _list[i];
      }
    };

     return null;
  }

}