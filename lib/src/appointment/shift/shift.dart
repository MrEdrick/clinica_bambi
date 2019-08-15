class Shift {
  String _id;
  String _description;
  String _observation;
  int _startTime;
  bool _state;
  
  Shift(this._id, this._description, this._observation, this._startTime, this._state);

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  String get observation => _observation;
  set observation(String observation) => _observation = observation;

  int get startTime => _startTime;
  set startTime(int startTime) => _startTime = startTime;

  bool get state => _state;
  set state(bool state) => _state = state;
}