import 'dart:async';

import 'procedureRequirement_constants.dart';
import 'procedureRequirement.dart';
import '../user/user_dao.dart';
import '../user/user_constants.dart';
import '../../firebase/firestore.dart';

class ProcedureRequirementDAO {
  ProcedureRequirementDAO();

  Future<String> save(Map<String, dynamic> datas) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(PROCEDURE_REQUIREMENT_COLLECTION);

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
    FireStoreApp _fireStoreApp = new FireStoreApp(PROCEDURE_REQUIREMENT_COLLECTION);

    if (await _fireStoreApp.updateItem(id, datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }
}
