import 'user.dart';

class UserService {
  static User _user = null;

  User get user => _user;
  set user(User user) => _user = user;
}