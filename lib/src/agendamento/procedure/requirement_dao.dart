import 'dart:async';

import 'procedure_constants.dart';
import 'procedure.dart';
import '../user/user_dao.dart';
import '../user/user_constants.dart';
import '../../firebase/firestore.dart';

class ProcedureDAO {
  ProcedureDAO();

  Future<String> save(Map<String, dynamic> datas) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(PROCEDURE_COLLECTION);

    if (await _fireStoreApp.addItem(datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<String> update(String id, Map<String, dynamic> datas) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(PROCEDURE_COLLECTION);

    if (await _fireStoreApp.updateItem(id, datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<Procedure> procedureExists(String description) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(PROCEDURE_COLLECTION);
    Procedure _procedure;

    await _fireStoreApp.ref
        .where('description', '==', description)
        .get()
        .then((querySnapshot) {
          if (querySnapshot.size > 0) {
            _procedure = new Procedure(
                querySnapshot.docs[0].id.toString(),
                querySnapshot.docs[0].data()["description"].toString());
          } else {
            _procedure = null;
          }
    });

    return _procedure;
  }
}
