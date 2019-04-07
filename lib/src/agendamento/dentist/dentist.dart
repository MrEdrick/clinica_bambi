class Dentist {
  String _id;
  String _name;
  String _state;
  
  Dentist(this._id, this._name, this._state);

  String get id => _id;
  set id(String id) => _id = id;

  String get name => _name;
  set name(String name) => _name = name;

  String get state => _state;
  set state(String name) => _state = state;
}