class AutoAppointmentSchedulingConfiguration {
  String _id;
  int _hourLimitToClientRemoveAutoAppointmentScheduling;
  List<String> _invalidDates;

  AutoAppointmentSchedulingConfiguration(
      this._id,
      this._hourLimitToClientRemoveAutoAppointmentScheduling,
      this._invalidDates);

  String get id => _id;
  set id(String id) => _id = id;

  int get hourLimitToClientRemoveAutoAppointmentScheduling =>
      _hourLimitToClientRemoveAutoAppointmentScheduling;
  set hourLimitToClientRemoveAutoAppointmentScheduling(
          int hourLimitToClientRemoveAutoAppointmentScheduling) =>
      _hourLimitToClientRemoveAutoAppointmentScheduling =
          hourLimitToClientRemoveAutoAppointmentScheduling;

  List<String> get invalidDates => _invalidDates;
  set invalidDates(List<String> invalidDates) => _invalidDates = invalidDates;

}
