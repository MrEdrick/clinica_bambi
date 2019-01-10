class Usuario {
  String _id;
  String _nome;
  String _email;


  Usuario( this._id, this._nome, this._email);

  String get id => _id;
  set id(String id) => _id = id;

  String get nome => _nome;
  set turno(String nome) => _nome = nome;

  String get email => _email;
  set email(String email) => _email = email;
}
