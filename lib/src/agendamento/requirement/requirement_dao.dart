import 'dart:async';

import 'requirement_constants.dart';
import 'requirement.dart';
import '../user/user_dao.dart';
import '../user/user_constants.dart';
import '../../firebase/firestore.dart';

class RequirementDAO {
  RequirementDAO();

  Future<Map<bool, String>> save(Map<String, dynamic> datas) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(REQUIREMENT_COLLECTION);

    Map<bool, String> result = (await _fireStoreApp.addItem(datas));
    
    _fireStoreApp.FireStoreOffLine();
    return result;
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
                querySnapshot.docs.first.id.toString(),
                querySnapshot.docs.first.data()["description"].toString(), 
                querySnapshot.docs.first.data()["state"].toString());
          } else {
            _requirement = null;
          }
    });

    return _requirement;
  }

  Future<String> delete(String id) async {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(REQUIREMENT_COLLECTION);
    if (await _fireStoreApp.deleteItem(id)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<List<Map>> getAllRequirementFilter(Map filter, Map orderBy) async {
    List<Map> _list = new List<Map>();
    FireStoreApp _fireStoreApp =
        new FireStoreApp(REQUIREMENT_COLLECTION);

    await (await _fireStoreApp.ref
            .where(filter.keys.first, '==', filter.values.first)
            .orderBy(orderBy.keys.first, orderBy.values.first)
            .get())
        .docs
        .forEach((doc) {
      
      Map map = new Map.from(doc.data());
      
      map['documentPath'] = doc.id;
      
      _list.add(map);
    });

    _fireStoreApp.FireStoreOffLine();
    return _list;
  }

}
