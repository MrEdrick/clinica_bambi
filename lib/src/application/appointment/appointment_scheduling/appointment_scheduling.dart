import '../shift/shift.dart';
import '../dentist/dentist.dart';
import '../agreement/agreement.dart';
import '../auto_appointment_scheduling/auto_appointment_scheduling.dart';
import 'package:intl/intl.dart';

class AppointmentScheduling {
  String _id;
  String _shiftId;
  String _hourId;
  String _minuteId;
  String _dentistId;
  String _agreementId;
  String _autoAppointmentSchedulingId;
  String _patient;
  String _email;
  String _telephone;
  String _dateAppointmentScheduling;
  String _userId;
  Shift _shift;
  Dentist _dentist;
  Agreement _agreement;
  AutoAppointmentScheduling _autoAppointmentScheduling;

  AppointmentScheduling(
      this._id,
      this._dateAppointmentScheduling,
      this._hourId,
      this._minuteId,
      this._shiftId,
      this._dentistId,
      this._agreementId,
      this._autoAppointmentSchedulingId,
      this._patient,
      this._email,
      this._telephone,
      this._userId,
      this._shift,
      this._dentist,
      this._agreement,
      this._autoAppointmentScheduling);

  String get id => _id;
  set id(String id) => _id = id;

  String get dateAppointmentSchedulingFormated {
    return new DateFormat('dd/MM/yyyy')
        .format(DateTime.parse(_dateAppointmentScheduling));
  }

  String get dateAppointmentScheduling => _dateAppointmentScheduling;
  set dateAppointmentScheduling(String dateAppointmentScheduling) =>
      _dateAppointmentScheduling = dateAppointmentScheduling;

  String get shiftId {
    if ((_shiftId == '') || (_shiftId == null)) {
      if ((_hourId == 'JVWNJdwwqjFXCbmuGWf0') ||
          (_hourId == 'Q14M2Diimon1ksVLO3TO') ||
          (_hourId == 'hql4fUJfU8vhoxaF7IkB') ||
          (_hourId == 'mUFFpnp6CP53gnEuS9DU')) {
        _shiftId = '1a5XNjDT8qfLQ53KSSxh';
      } else {
        _shiftId = 'fBXihJRGPTPepfkfbxSs';
      }
    }

    return _shiftId;
  }

  set shiftId(String shiftId) {
    _shiftId = shiftId;

    if ((_shiftId == '') || (_shiftId == null)) {
      if ((_hourId == 'JVWNJdwwqjFXCbmuGWf0') ||
          (_hourId == 'Q14M2Diimon1ksVLO3TO') ||
          (_hourId == 'hql4fUJfU8vhoxaF7IkB') ||
          (_hourId == 'mUFFpnp6CP53gnEuS9DU')) {
        _shiftId = '1a5XNjDT8qfLQ53KSSxh';
      } else {
        _shiftId = 'fBXihJRGPTPepfkfbxSs';
      }
    }
  }

  String get hourId => _hourId;
  set hourId(String hourId) => _hourId = hourId;

  String get minuteId => _minuteId;
  set minuteId(String minuteId) => _minuteId = minuteId;

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  String get agreementId => _agreementId;
  set agreementId(String agreementId) => _agreementId = agreementId;

  String get autoAppointmentSchedulingId => _autoAppointmentSchedulingId;
  set autoAppointmentSchedulingId(String autoAppointmentSchedulingId) =>
      _autoAppointmentSchedulingId = autoAppointmentSchedulingId;

  String get patient => _patient;
  set patient(String patient) => _patient = patient;

  String get email => _email;
  set email(String email) => _email = email;

  String get telephone => _telephone;
  set telephone(String telephone) => _telephone = telephone;

  String get userId => _userId;
  set userId(String userId) => _userId = userId;

  Shift get shift => _shift;
  set shift(Shift shift) => _shift = shift;

  Dentist get dentist => _dentist;
  set dentist(Dentist dentist) => _dentist = dentist;

  Agreement get agreement => _agreement;
  set agreement(Agreement agreement) => _agreement = agreement;

  AutoAppointmentScheduling get autoAppointmentScheduling =>
      _autoAppointmentScheduling;
  set autoAppointmentScheduling(
          AutoAppointmentScheduling autoAppointmentScheduling) =>
      _autoAppointmentScheduling = autoAppointmentScheduling;
}
