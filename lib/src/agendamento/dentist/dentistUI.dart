import 'package:angular_components/model/ui/display_name.dart';
import 'dentist.dart';

class DentistUI implements HasUIDisplayName {
  final String id;
  final String name;
  final String state;
  
  const DentistUI(this.id, this.name, this.state);

  @override
  String get uiDisplayName => name;
}