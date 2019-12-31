import '../shift/shift.dart';
import '../dentist/dentist.dart';
import '../interval/interval.dart';

class AttendanceInterval {
  String _id;
  String _dentistId;
  String _shiftId;
  String _intervalId;
  Shift _shift;
  Dentist _dentist;
  Interval _interval;

  AttendanceInterval(
      this._id, this._dentistId, this._shiftId, this._intervalId,
      this._dentist, this._shift, this._interval);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  String get shiftId => _shiftId;
  set shiftId(String shiftId) => _shiftId = shiftId;

  String get intervalId => _intervalId;
  set intervalId(String intervalId) => _intervalId = intervalId;

  Shift get shift => _shift;
  set shift(Shift shift) => _shift = shift;

  Dentist get dentist => _dentist;
  set dentist(Dentist dentist) => _dentist = dentist;

  Interval get interval => _interval;
  set interval(Interval interval) => _interval = interval;
}
