import 'package:angular_components/model/ui/display_name.dart';

class Minute implements HasUIDisplayName {
  final String minuteId;
  final String description;
  final String state;
  
  const Minute(this.minuteId, this.description, this.state);

  @override
  String get uiDisplayName => description;
}