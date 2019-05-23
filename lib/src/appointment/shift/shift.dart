import 'package:angular_components/model/ui/display_name.dart';

class Shift implements HasUIDisplayName {
  final String id;
  final String description;
  final String state;
  
  const Shift(this.id, this.description, this.state);

  @override
  String get uiDisplayName => description;
}