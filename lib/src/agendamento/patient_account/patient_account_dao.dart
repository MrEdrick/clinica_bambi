import 'dart:async';

import '../../firebase/firestore.dart';
import 'package:encrypt/encrypt.dart';
import '../../agendamento/patient_account/patient_account.dart';

class PatientAccountDAO {
  PatientAccountDAO();

  Future<String> save(Map<String, dynamic> datas) async {
    FireStoreApp _fireStoreApp = new FireStoreApp('patientsAccount');

    if (await _fireStoreApp.addItem(datas)) {
      _fireStoreApp.FireStoreOffLine();
      return '';
    } else {
      _fireStoreApp.FireStoreOffLine();
      return 'Error';
    }
  }

  PatientAccount getPatiantAccount(String email, String password) {
    FireStoreApp fireStoreApp = new FireStoreApp('patientAccount');

    fireStoreApp.ref
        .where('email', '==', email)
        .where('password', '==', RSAKeyParser().parse(password))
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

  bool emailExists(String email) {
    FireStoreApp fireStoreApp = new FireStoreApp('patientAccount');

    fireStoreApp.ref
        .where('email', '==', email)
        .get()
        .then((querySnapshot) {
        return querySnapshot.size > 0;
    });
  }
}
