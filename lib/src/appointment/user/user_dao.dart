import 'dart:async';

import '../../firebase/auth.dart';
import 'user.dart';
import 'user_service.dart';

class UserDAO {
  UserDAO();

  Future<User> authWithEmailAndPassword(String email, String password) async { 
    if (await new AuthApp().login(email, password) == '') {
      return new UserService().user;
    }
  }
}
