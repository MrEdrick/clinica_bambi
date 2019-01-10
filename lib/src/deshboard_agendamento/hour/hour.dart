import 'package:angular_components/model/ui/display_name.dart';

class Hour implements HasUIDisplayName {
  final String hourId;
  final String description;
  final String state;
  
  const Hour(this.hourId, this.description, this.state);

  @override
  String get uiDisplayName => description;
}