import 'package:intl/intl.dart';

import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'auto_appointment_scheduling_constants.dart';

import '../../clinic/shift/shift.dart';
import '../../clinic/agreement/agreement.dart';
import '../../dentist/dentist/dentist.dart';
import '../../procedure/procedure/procedure.dart';

class AutoAppointmentScheduling extends Collection {
  String _id;
  String _shiftId;
  String _dentistId;
  String _agreementId;
  String _procedureId;
  String _patient;
  String _email;
  String _telephone;
  String _dateAppointmentScheduling;
  String _patientAccountId;
  Shift _shift;
  Dentist _dentist;
  Agreement _agreement;
  Procedure _procedure;

  AutoAppointmentScheduling(
      this._id,
      this._dateAppointmentScheduling,
      this._shiftId,
      this._dentistId,
      this._agreementId,
      this._procedureId,
      this._patient,
      this._email,
      this._telephone,
      this._patientAccountId,
      this._shift,
      this._dentist,
      this._agreement,
      this._procedure)
      : super('', '', null, '', '', null);

  String get id => _id;
  set id(String id) => _id = id;

  String get dateAppointmentSchedulingFormated {
    return new DateFormat('dd/MM/yyyy')
        .format(DateTime.parse(_dateAppointmentScheduling));
  }

  String get dateAppointmentScheduling => _dateAppointmentScheduling;
  set dateAppointmentScheduling(String dateAppointmentScheduling) =>
      _dateAppointmentScheduling = dateAppointmentScheduling;

  String get shiftId => _shiftId;
  set shiftId(String shiftId) => _shiftId = shiftId;

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  String get agreementId => _agreementId;
  set agreementId(String agreementId) => _agreementId = agreementId;

  String get procedureId => _procedureId;
  set procedureId(String procedureId) => _procedureId = procedureId;

  String get patient => _patient;
  set patient(String patient) => _patient = patient;

  String get email => _email;
  set email(String email) => _email = email;

  String get telephone => _telephone;
  set telephone(String telephone) => _telephone = telephone;

  String get patientAccountId => _patientAccountId;
  set patientAccountId(String patientAccountId) =>
      _patientAccountId = patientAccountId;

  Shift get shift => _shift;
  set shift(Shift shift) => _shift = shift;

  Dentist get dentist => _dentist;
  set dentist(Dentist dentist) => _dentist = dentist;

  Agreement get agreement => _agreement;
  set agreement(Agreement agreement) => _agreement = agreement;

  Procedure get procedure => _procedure;
  set procedure(Procedure procedure) => _procedure = procedure;
}
