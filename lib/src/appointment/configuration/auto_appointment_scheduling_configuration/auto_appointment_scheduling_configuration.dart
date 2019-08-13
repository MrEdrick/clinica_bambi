class AutoAppointmentSchedulingConfiguration {
  String _id;
  int _hourLimitToClientRemoveAutoAppointmentScheduling;

  AutoAppointmentSchedulingConfiguration(
      this._id, this._hourLimitToClientRemoveAutoAppointmentScheduling);

  String get id => _id;
  set id(String id) => _id = id;

  int get hourLimitToClientRemoveAutoAppointmentScheduling =>
      _hourLimitToClientRemoveAutoAppointmentScheduling;
  set hourLimitToClientRemoveAutoAppointmentScheduling(
          int hourLimitToClientRemoveAutoAppointmentScheduling) =>
      _hourLimitToClientRemoveAutoAppointmentScheduling =
          hourLimitToClientRemoveAutoAppointmentScheduling;
}
