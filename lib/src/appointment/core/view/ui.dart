import 'package:angular_components/model/ui/display_name.dart';

class UI implements HasUIDisplayName {
  final String id;
  final String description;
  
  const UI(this.id, this.description);

  @override
  String get uiDisplayName => description;
}