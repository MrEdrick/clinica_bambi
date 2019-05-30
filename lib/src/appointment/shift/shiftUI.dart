import 'package:angular_components/model/ui/display_name.dart';

class ShiftUI implements HasUIDisplayName {
  final String _id;
  final String _description;
  
  const ShiftUI(this._id, this._description);

  @override
  String get uiDisplayName => _description;

  String get id => _id;
}