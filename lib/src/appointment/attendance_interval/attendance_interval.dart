class AttendanceInterval {
  String _id;
  String _dentistId;
  String _shiftId;
  String _intervalId;

  AttendanceInterval(this._id, this._dentistId, this._shiftId, this._intervalId);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  String get shiftId => _shiftId;
  set shiftId(String shiftId) => _shiftId = shiftId;

  String get intervalId => _intervalId;
  set intervalId(String intervalId) => _intervalId = intervalId;
}
