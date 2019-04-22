import 'package:angular_components/model/ui/display_name.dart';

class ShiftUI implements HasUIDisplayName {
  final String id;
  final String description;
  
  const ShiftUI(this.id, this.description);

  @override
  String get uiDisplayName => description;
}