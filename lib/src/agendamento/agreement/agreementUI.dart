import 'package:angular_components/model/ui/display_name.dart';

class AgreementUI implements HasUIDisplayName {
  final String id;
  final String description;
  
  const AgreementUI(this.id, this.description);

  @override
  String get uiDisplayName => description;
}