class Shift {
  String _id;
  String _description;
  bool _state;
  
  Shift(this._id, this._description, this._state);

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  bool get state => _state;
  set state(bool state) => _state = state;
}