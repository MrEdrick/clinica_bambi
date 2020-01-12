import 'package:angular_components/model/ui/display_name.dart';

class AvailableTimesUI implements HasUIDisplayName {
  final String id;
  final String description;
  
  const AvailableTimesUI(this.id, this.description);

  @override
  String get uiDisplayName => description;
}