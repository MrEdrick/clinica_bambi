import 'package:angular/angular.dart';

import 'factory_field.dart';
import '../../model/field.dart';
import '../../model/constants.dart';

class FactoryFilterField extends FactoryField {
  FactoryFilterField(
      Field field,
      ComponentLoader loader,
      ViewContainerRef viewContainerRefField)
      : super(field, loader, viewContainerRefField, null);

  ComponentRef addField() {
    ComponentRef _componentRefEditField = null;

    return _componentRefEditField;
  }

}
