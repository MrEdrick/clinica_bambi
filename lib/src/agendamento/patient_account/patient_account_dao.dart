import 'dart:async';
import 'dart:convert';

import '../user/user_dao.dart';
import '../user/user_constants.dart';
import '../../firebase/firestore.dart';
import '../../agendamento/patient_account/patient_account.dart';

class PatientAccountDAO {
  PatientAccountDAO();

  Future<String> save(Map<String, dynamic> datas) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp('patientsAccount');

    if (await _fireStoreApp.addItem(datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<PatientAccount> getPatiantAccount(String email, String password) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp('patientAccount');

    _fireStoreApp.ref
        .where('email', '==', email)
        .where('password', '==', password)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size == 0) {
        return null;
      } else {
        return new PatientAccount(
            querySnapshot.docs[0].data()["id"].toString(),
            querySnapshot.docs[0].data()["email"].toString(),
            querySnapshot.docs[0].data()["name"].toString(),
            querySnapshot.docs[0].data()["password"].toString());
      }
    });
  }

  Future<bool> emailExists(String email) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp('patientAccount');

    _fireStoreApp.ref
        .where('email', '==', email)
        .get()
        .then((querySnapshot) {
        return querySnapshot.size > 0;
    });
  }
}
