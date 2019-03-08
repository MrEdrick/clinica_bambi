import 'package:angular_components/model/ui/display_name.dart';

class Agreement implements HasUIDisplayName {
  final String agreementId;
  final String description;
  final String state;
  
  const Agreement(this.agreementId, this.description, this.state);

  @override
  String get uiDisplayName => description;
}