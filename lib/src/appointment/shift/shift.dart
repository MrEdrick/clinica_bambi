class Shift {
  String _id;
  String _description;
  String _observation;
  int _startTimeHour;
  int _startTimeMinute;
  int _endTimeHour;
  int _endTimeMinute;
  bool _state;

  Shift(
      this._id,
      this._description,
      this._observation,
      this._startTimeHour,
      this._startTimeMinute,
      this._endTimeHour,
      this._endTimeMinute,
      this._state);

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  String get observation => _observation;
  set observation(String observation) => _observation = observation;

  int get startTimeHour => _startTimeHour;
  set startTimeHour(int startTimeHour) => _startTimeHour = startTimeHour;

  int get startTimeMinute => _startTimeMinute;
  set startTimeMinute(int startTimeMinute) =>
      _startTimeMinute = startTimeMinute;

  int get endTimeHour => _endTimeHour;
  set endTimeHour(int endTimeHour) => _endTimeHour = endTimeHour;

  int get endTimeMinute => _endTimeMinute;
  set endTimeMinute(int endTimeMinute) => _endTimeMinute = endTimeMinute;

  bool get state => _state;
  set state(bool state) => _state = state;
}
