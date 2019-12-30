import 'package:angular_components/model/ui/display_name.dart';

class IntervalUI implements HasUIDisplayName {
  final String id;
  final String description;
  
  const IntervalUI(this.id, this.description);

  @override
  String get uiDisplayName => description;
}