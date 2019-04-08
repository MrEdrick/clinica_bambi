class Requirement {
  String _id;
  String _description;
  String _state;

  Requirement( this._id, this._description, this._state);

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  String get state => _state;
  set state(String state) => _state = state;
}
