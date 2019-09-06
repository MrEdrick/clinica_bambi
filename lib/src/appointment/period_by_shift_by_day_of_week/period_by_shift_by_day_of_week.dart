class PeriodByShiftByDayOfWeek {
  String _id;
  String _shiftId;
  String _dayOfWeek;
  String _description;
  bool _state;
  
  PeriodByShiftByDayOfWeek(this._id, this._shiftId, this._dayOfWeek, this._description, this._state);

  String get id => _id;
  set id(String id) => _id = id;

  String get shiftId => _shiftId;
  set shiftId(String shiftId) => _shiftId = shiftId;

  String get dayOfWeek => _dayOfWeek;
  set dayOfWeek(String dayOfWeek) => _dayOfWeek = dayOfWeek;

  String get description => _description;
  set description(String description) => _description = description;

  bool get state => _state;
  set state(bool state) => _state = state;
}