import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'patient_account_constants.dart';

class PatientAccount extends Collection {
  String _id;
  String _email;
  String _name;
  String _password;
  bool _state;

  PatientAccount(this._id, this._email, this._name, this._password, this._state)
      : super('', '', null, '', '', null);

  String get id => _id;
  set id(String id) => _id = id;

  String get name => _name;
  set name(String name) => _name = name;

  String get email => _email;
  set email(String email) => _email = email;

  String get password => _password;
  set password(String password) => _password = password;

  bool get state => _state;
  set state(bool state) => _state = state;
}
