import 'dart:async';

import 'patient_account_constants.dart';
import '../user/user_dao.dart';
import '../user/user_constants.dart';
import '../../firebase/firestore.dart';
import '../../agendamento/patient_account/patient_account.dart';

class PatientAccountDAO {
  PatientAccountDAO();

  Future<String> save(Map<String, dynamic> datas) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(PATIENT_ACCOUNT_COLLECTION);

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
    FireStoreApp _fireStoreApp = new FireStoreApp(PATIENT_ACCOUNT_COLLECTION);

    if (await _fireStoreApp.updateItem(id, datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  Future<PatientAccount> getPatiantAccount(String email, String password) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(PATIENT_ACCOUNT_COLLECTION);
    PatientAccount _patientAccount;

    await _fireStoreApp.ref
        .where('email', '==', email)
        .where('password', '==', password)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.size == 0) {
        _patientAccount = null;
      } else {
         _patientAccount = new PatientAccount(
            querySnapshot.docs[0].id.toString(),
            querySnapshot.docs[0].data()["email"].toString(),
            querySnapshot.docs[0].data()["name"].toString(),
            querySnapshot.docs[0].data()["password"].toString());
      }
    });

    return _patientAccount;
  }

  Future<PatientAccount> emailExists(String email) async {
    await new UserDAO().authWithEmailAndPassword(EMAIL_ADM, PASSWORD_ADM);
    FireStoreApp _fireStoreApp = new FireStoreApp(PATIENT_ACCOUNT_COLLECTION);
    PatientAccount _patientAccount;

    await _fireStoreApp.ref
        .where('email', '==', email)
        .get()
        .then((querySnapshot) {
          if (querySnapshot.size > 0) {
            _patientAccount = new PatientAccount(
                querySnapshot.docs[0].id.toString(),
                querySnapshot.docs[0].data()["email"].toString(),
                querySnapshot.docs[0].data()["name"].toString(),
                querySnapshot.docs[0].data()["password"].toString());
          } else {
            _patientAccount = null;
          }
    });

    return _patientAccount;
  }
}
