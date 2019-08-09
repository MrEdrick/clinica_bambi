class Shift {
  String _id;
  String _description;
  String _observation;
  bool _state;
  
  Shift(this._id, this._description, this._observation, this._state);

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  String get observation => _observation;
  set observation(String observation) => _observation = observation;

  bool get state => _state;
  set state(bool state) => _state = state;
}