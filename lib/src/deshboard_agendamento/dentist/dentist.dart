import 'package:angular_components/model/ui/display_name.dart';

class Dentist implements HasUIDisplayName {
  final String dentistId;
  final String name;
  final String state;
  
  const Dentist(this.dentistId, this.name, this.state);

  @override
  String get uiDisplayName => name;
}