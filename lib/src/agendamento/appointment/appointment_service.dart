import 'appointment.dart';

class AppointmentService {
  static Appointment _appointment;

  Appointment get appointment => _appointment;
  set appointment(Appointment appointment) => _appointment = appointment;
}