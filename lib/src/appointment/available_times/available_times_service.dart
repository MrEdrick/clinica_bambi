import 'dart:async';
import 'package:angular_components/angular_components.dart';
import 'package:time/time.dart';

import '../appointment_scheduling/appointment_scheduling_service.dart';
import '../attendance_interval/attendance_interval_service.dart';
import '../attendance_interval/attendance_interval.dart';
import '../shift/shift_service.dart';
import '../shift/shift.dart';
import 'available_times.dart';
import 'available_timesUI.dart';

class AvailableTimesService {
  static AvailableTimes _availableTimes;
  static List<AvailableTimes> _list = new List<AvailableTimes>();
  static List<Map> _availableTimesList = new List<Map>();

  final appointmentSchedulingService = new AppointmentSchedulingService();
  final attendanceIntervalService = new AttendanceIntervalService();
  final shiftService = new ShiftService();

  AvailableTimes get availableTimes => _availableTimes;
  set availableTimes(AvailableTimes availableTimes) =>
      _availableTimes = availableTimes;

  void clearAllAvailableTimesList() {
    _list.clear();
    _availableTimesList.clear();
  }

  Future<List<AvailableTimes>> getAllAvailableTimesByShiftIdDentistId(
      String shiftId, String dentistId, Date date) async {
    List<Map> _appointmentSchedulingByDate = new List<Map>();
    Shift _shift;
    AttendanceInterval _attendanceInterval;
    Duration startTime;
    Duration endTime;

    if ((_availableTimesList != null) && (_availableTimesList?.length != 0)) {
      return _list;
    }

    clearAllAvailableTimesList();
    _appointmentSchedulingByDate.clear();

    appointmentSchedulingService.clearAllAppointmentSchedulingByDate();

    await appointmentSchedulingService.getAllAppointmentSchedulingByDate(date);

    _shift = await shiftService.getShiftById(shiftId);

    if (_shift == null) {
      return _list;
    }

    startTime = _shift.startTimeHour.hours + _shift.startTimeMinute.minutes;
    endTime = _shift.endTimeHour.hours + _shift.endTimeMinute.minutes;

    _attendanceInterval = await attendanceIntervalService
        .getAttendanceIntervalByDentistIdShiftId(dentistId, shiftId);

    if (_attendanceInterval == null) {
      return _list;
    }

    if (_attendanceInterval.intervalId.isEmpty) {
      return _list;
    }

    for (startTime;
        startTime <= endTime;
        startTime = startTime + _attendanceInterval.interval.time.minutes) {
      String _startTimeFormated = startTime.toString().length == 14
          ? '0' + startTime.toString()
          : startTime.toString();

      _appointmentSchedulingByDate = await appointmentSchedulingService
          .getAppointmentSchedulingWithFilterFromList(date, {
        "dentistId": dentistId,
        "shiftId": shiftId,
        "horary": _startTimeFormated.substring(0, 5)
      });

      if ((_appointmentSchedulingByDate?.length == 0)) {
        _list.add(new AvailableTimes(
            _startTimeFormated.substring(0, 5),
            int.parse(_startTimeFormated.substring(0, 2)),
            int.parse(_startTimeFormated.substring(3, 5))));
      }
    }

    _availableTimesList.forEach((availableTimes) {
      _list.add(turnMapInAvailableTimes(availableTimes));
    });

    return _list;
  }

  Future<List<AvailableTimesUI>> getAllAvailableTimesUIAcives(
      String shiftId, String dentistId, Date date) async {
    if ((_availableTimesList == null) || (_availableTimesList?.length == 0)) {
      await getAllAvailableTimesByShiftIdDentistId(shiftId, dentistId, date);
    }

    List<AvailableTimesUI> _listAvailableTimesUI = new List<AvailableTimesUI>();

    for (AvailableTimes _availableTimes in _list) {
      _listAvailableTimesUI.add(
          new AvailableTimesUI(_availableTimes.time, _availableTimes.time));
    }

    return _listAvailableTimesUI;
  }

  AvailableTimes returnEmptyAvailableTimes() {
    return new AvailableTimes("", 0, 0);
  }

  AvailableTimes turnMapInAvailableTimes(Map map) {
    return new AvailableTimes(map["time"], map["hour"], map["minute"]);
  }
}
