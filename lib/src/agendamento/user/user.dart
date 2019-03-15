class User {
  String _id;
  String _name;
  String _email;


  User( this._id, this._name, this._email);

  String get id => _id;
  set id(String id) => _id = id;

  String get name => _name;
  set turno(String nome) => _name = nome;

  String get email => _email;
  set email(String email) => _email = email;
}
