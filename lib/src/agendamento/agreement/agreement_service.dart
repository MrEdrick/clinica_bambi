import 'dart:async';
import 'agreement.dart';
import '../../firebase/firestore.dart';

class AgreementService {
  static List<Agreement> _list;

  Future<List<Agreement>> getAllAgreementAcives() async {
    if (_list != null) {
      return _list;
    }
    
    FireStoreApp fireStoreApp = new FireStoreApp('agreement');

    fireStoreApp.ref
      .where('state', '==', 'A')
      .orderBy('description', 'asc')
      .get().then((querySnapshot) {
        int i = 0;
        _list = new List<Agreement>(querySnapshot.size);
        querySnapshot.forEach((doc) {
          _list[i] = new Agreement(doc.id, doc.data()["description"], doc.data()["state"]);
          i++;
        });
      }).then((onValue) {
        fireStoreApp.FireStoreOffLine();
      });

    return _list;
  }

  Future<Agreement> getAgreementById(String agreementId) async {
    if (_list == null) {
      await getAllAgreementAcives();
    }

    for (var i = 0; i < _list.length; i++) {
      if (_list[i].agreementId == agreementId) {
        return _list[i];
      }
    };

     return null;
  }

}