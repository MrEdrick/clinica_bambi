import 'dart:async';
import 'package:firebase/firebase.dart' as fb;
import '../agendamento/usuario/usuario.dart';
import '../agendamento/usuario/usuario_service.dart';

class AuthApp {
  final fb.Auth auth;
  static fb.UserCredential userCredential;

  AuthApp() : this.auth = fb.auth();

  void sendEmailVerification() async {
    try {
        // you will get the verification email in selected language
        // url should be any authorized domain in your console - we use here,
        // for this example, authDomain because it is whitelisted by default
        // More info: https://firebase.google.com/docs/auth/web/passing-state-in-email-actions
      await auth.currentUser.sendEmailVerification(
        new fb.ActionCodeSettings(url: "https://bambi-210400.firebaseapp.com"));
    } catch (e) {
    }
  }

  Future<String> login(String email, String password) async {
    try {
      await auth.setPersistence('session');
      userCredential = await auth.signInWithEmailAndPassword(email, password);
      new UsuarioService().usuario = new Usuario(userCredential.user.uid, userCredential.user.displayName, userCredential.user.email);
      return '';
    } catch (e) {
      return e.toString();
    }

  }

  Future<String> registerUser(String email, String password) async {

    if (email.isNotEmpty && password.isNotEmpty) {
      var trySignin = false;
      try {
        // Modifies persistence state. More info: https://firebase.google.com/docs/auth/web/auth-state-persistence
        await auth.setPersistence('session');
        await auth.createUserWithEmailAndPassword(email, password);
      } on fb.FirebaseError catch (e) {
        if (e.code == "auth/email-already-in-use") {
          trySignin = true;
        }
      } catch (e) {
        return e.toString();
      }

      if (trySignin) {
        try {
          await auth.signInWithEmailAndPassword(email, password);
          new UsuarioService().usuario = new Usuario(auth.currentUser.uid, auth.currentUser.displayName, auth.currentUser.email);
          return '';
        } catch (e) {
          return e.toString();
        }
      }
    } else {
      return "Por favor, preencha os dados corretamente.";
    }
  }
}