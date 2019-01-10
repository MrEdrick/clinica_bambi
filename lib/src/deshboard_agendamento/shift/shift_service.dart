import 'dart:async';
import 'shift.dart';
import '../../firebase/firestore.dart';

class ShiftService {
  static List<Shift> _list;

  Future<List<Shift>> getAllShiftAcives() async {
    if (_list != null) {
      return _list;
    }
    
    FireStoreApp fireStoreApp = new FireStoreApp('shift');

    await fireStoreApp.ref
      .where('state', '==', 'A')
      .orderBy('description', 'asc')
      .get().then((querySnapshot) {
        int i = 0;
        _list = new List<Shift>(querySnapshot.size);
        querySnapshot.forEach((doc) {
          _list[i] = new Shift(doc.id, doc.data()["description"], doc.data()["state"]);
          i++;
        });
      }).then((onValue) {
        fireStoreApp.FireStoreOffLine();
      });

    return _list;
  }

  Future<Shift> getShiftById(String shiftId, String hourId) async {
    if ((shiftId == '') || (shiftId == null)) {
      if ((hourId == 'JVWNJdwwqjFXCbmuGWf0')
          || (hourId == 'Q14M2Diimon1ksVLO3TO')
          || (hourId == 'hql4fUJfU8vhoxaF7IkB')
          || (hourId == 'mUFFpnp6CP53gnEuS9DU')) {
          shiftId = '1a5XNjDT8qfLQ53KSSxh';
      } else {
          shiftId = 'fBXihJRGPTPepfkfbxSs';
      }
    }

    if (_list == null) {
      await getAllShiftAcives();
    }

    for (var i = 0; i < _list.length; i++) {
      if (_list[i].shiftId == shiftId) {
        return _list[i];
      }
    };

     return null;
  }

}