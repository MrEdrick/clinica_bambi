import 'package:angular_components/model/ui/display_name.dart';
import 'dentist.dart';

class DentistUI implements HasUIDisplayName {
  final String id;
  final String name;
  
  const DentistUI(this.id, this.name);

  @override
  String get uiDisplayName => name;
}