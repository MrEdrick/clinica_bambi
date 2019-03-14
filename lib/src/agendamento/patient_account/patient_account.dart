class PatientAccount {
  String _id;
  String _email;
  String _name;
  String _password;


  PatientAccount( this._id, this._email, this._name, this._password);

  String get id => _id;
  set id(String id) => _id = id;

  String get name => _name;
  set turno(String name) => _name = name;

  String get email => _email;
  set email(String email) => _email = email;

  String get password => _password;
  set password(String password) => _password = password;
}
