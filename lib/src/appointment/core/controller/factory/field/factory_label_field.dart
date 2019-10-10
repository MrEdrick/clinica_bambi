import 'package:angular/angular.dart';

import 'factory_field.dart';
import '../../../model/field.dart';
import '../../../model/constants.dart';

import '../../view/label/boolean_label_component.template.dart'
    as boolean_label_component;
import '../../view/label/string_label_component.template.dart'
    as string_label_component;

class FactoryLabelField extends FactoryField {
  FactoryLabelField(Field field, ComponentLoader loader,
      ViewContainerRef viewContainerRefField)
      : super(field, loader, viewContainerRefField, null);

  ComponentRef addField() {
    ComponentRef _componentRefField = null;

    switch (super.field.type.primaryType) {
      case FIELD_TYPE_STRING:
        {
          _componentRefField = _addStringLabel();
        }
        break;

      case FIELD_TYPE_BOOLEAN:
        {
          _componentRefField = _addBooleanLabel();
        }
        break;
    }

    return _componentRefField;
  }

  ComponentRef _addStringLabel() {
    ComponentFactory<string_label_component.StringLabelComponent>
        componentFactoryLabel =
        string_label_component.StringLabelComponentNgFactory;

    ComponentRef componentRefLabel = super
        .loader
        .loadNextToLocation(componentFactoryLabel, super.viewContainerRefField);

    componentRefLabel.instance.title = field.title;
    componentRefLabel.instance.value = field.value;
    componentRefLabel.instance.componentRef = componentRefLabel;

    return componentRefLabel;
  }

  ComponentRef _addBooleanLabel() {
    ComponentFactory<boolean_label_component.BooleanLabelComponent>
        componentFactoryLabel =
        boolean_label_component.BooleanLabelComponentNgFactory;

    ComponentRef componentRefLabel = super
        .loader
        .loadNextToLocation(componentFactoryLabel, super.viewContainerRefField);

    componentRefLabel.instance.title = field.title;
    componentRefLabel.instance.value = field.value;
    componentRefLabel.instance.componentRef = componentRefLabel;

    return componentRefLabel;
  }
}
