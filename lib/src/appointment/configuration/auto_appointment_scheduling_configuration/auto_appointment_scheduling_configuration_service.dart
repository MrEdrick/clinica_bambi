import 'auto_appointment_scheduling_configuration.dart';
import 'auto_appointment_scheduling_configuration_constants.dart';
import 'auto_appointment_scheduling_configuration_dao.dart';

class AutoAppointmentSchedulingConfigurationService {
  static AutoAppointmentSchedulingConfiguration
      _autoAppointmentSchedulingConfiguration;

  AutoAppointmentSchedulingConfiguration
      get autoAppointmentSchedulingConfiguration =>
          _autoAppointmentSchedulingConfiguration;
  set autoAppointmentSchedulingConfiguration(
          AutoAppointmentSchedulingConfiguration
              autoAppointmentSchedulingConfiguration) =>
      _autoAppointmentSchedulingConfiguration =
          autoAppointmentSchedulingConfiguration;

  Future<AutoAppointmentSchedulingConfiguration> getAllConfiguration() async {
    _autoAppointmentSchedulingConfiguration =
        turnMapInAutoAppointmentSchedulingConfiguration(
            (await new AutoAppointmentSchedulingConfigurationDAO()
                    .getAllConfigurationFilter({}, []))
                .first);

    return _autoAppointmentSchedulingConfiguration;
  }

  AutoAppointmentSchedulingConfiguration
      turnMapInAutoAppointmentSchedulingConfiguration(Map map) {
    if (map == null) {
      return null;
    }
    return new AutoAppointmentSchedulingConfiguration(
        map["documentPath"],
        int.parse(
            map[HOUR_LIMIT_TO_CLIENT_REMOVE_AUTO_APPOINTMENT_SCHEDULING_FIELD]),
        map[INVALID_DATES]);
  }
}
