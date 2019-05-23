import 'package:angular_components/model/ui/display_name.dart';

class ProcedureUI implements HasUIDisplayName {
  final String id;
  final String description;
  
  const ProcedureUI(this.id, this.description);

  @override
  String get uiDisplayName => description;
}