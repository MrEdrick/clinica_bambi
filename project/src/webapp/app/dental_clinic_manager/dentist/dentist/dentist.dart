class Dentist {
  String _id;
  String _name;
  bool _state;
  
  Dentist(this._id, this._name, this._state);

  String get id => _id;
  set id(String id) => _id = id;

  String get name => _name;
  set name(String name) => _name = name;

  bool get state => _state;
  set state(bool state) => _state = state;
}