class Interval {
  String _id;
  int _time;
  bool _state;
  
  Interval(this._id, this._time, this._state);

  String get id => _id;
  set id(String id) => _id = id;

  int get time => _time;
  set time(int time) => _time = time;

  bool get state => _state;
  set state(bool state) => _state = state;
}