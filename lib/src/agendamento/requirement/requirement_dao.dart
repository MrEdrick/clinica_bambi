import 'dart:async';

import 'requirement_constants.dart';
import 'requirement.dart';
import '../user/user_dao.dart';
import '../user/user_constants.dart';
import '../../firebase/firestore.dart';

class RequirementDAO {
  RequirementDAO();

  Future<String> save(Map<String, dynamic> datas) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(REQUIREMENT_COLLECTION);

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
    FireStoreApp _fireStoreApp = new FireStoreApp(REQUIREMENT_COLLECTION);

    if (await _fireStoreApp.updateItem(id, datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<Requirement> requirementExists(String description) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(REQUIREMENT_COLLECTION);
    Requirement _requirement;

    await _fireStoreApp.ref
        .where('description', '==', description)
        .get()
        .then((querySnapshot) {
          if (querySnapshot.size > 0) {
            _requirement = new Requirement(
                querySnapshot.docs[0].id.toString(),
                querySnapshot.docs[0].data()["description"].toString(), 
                querySnapshot.docs[0].data()["state"].toString());
          } else {
            _requirement = null;
          }
    });

    return _requirement;
  }
}
