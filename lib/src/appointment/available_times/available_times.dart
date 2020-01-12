class AvailableTimes {
  String _time;
  int _hour;
  int _minute;

  AvailableTimes(this._time, this._hour, this._minute);

  String get time => _time;
  set time(String time) => _time = time;

  int get hour => _hour;
  set hour(int hour) => _hour = hour;

  int get minute => _minute;
  set minute(int minute) => _minute = minute;
}