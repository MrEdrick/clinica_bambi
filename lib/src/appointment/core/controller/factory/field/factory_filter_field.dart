import 'package:angular/angular.dart';

import 'factory_field.dart';
import '../../../model/field/field.dart';
import '../../../model/field/key_type/primary_key_type.dart';
import '../../../model/field/key_type/foreign_key_type.dart';
import '../../../constants/constants.dart';

import '../../view/edit/dropdown_multi_select_component.template.dart'
    as dropdown_multi_select_component;
import '../../view/edit/input_text_component.template.dart'
    as input_text_component;
import '../../view/edit/checkbox_component.template.dart' as checkbox_component;
import '../../view/edit/datepicker_select_component.template.dart'
    as datepicker_component;

class FactoryFilterField extends FactoryField {
  FactoryFilterField(Field field, ComponentLoader loader,
      ViewContainerRef viewContainerRefField)
      : super(field, loader, viewContainerRefField, null);

  ComponentRef addField() {
    ComponentRef _componentRefEditField = null;

    if ((super.field.type.type == FIELD_TYPE_FOREIGN_KEY) || (super.field.type.type == FIELD_TYPE_PRIMARY_KEY)) {
      _componentRefEditField = _addDropdownMultiSelect();
    } else {
      switch (super.field.type.primaryType) {
        case FIELD_TYPE_VALUE_STRING:
          {
            _componentRefEditField = _addInputText();
          }
          break;

        case FIELD_TYPE_VALUE_BOOLEAN:
          {
            _componentRefEditField = _addCheckBox();
          }
          break;

        case FIELD_TYPE_VALUE_DATE:
          {
            _componentRefEditField = _addDatepicker();
          }
          break;
      }
    }

    return _componentRefEditField;
  }

  ComponentRef _addDropdownMultiSelect() {
    ComponentFactory<
            dropdown_multi_select_component.DropdownMultiSelectComponent>
        componentFactorySelect =
        dropdown_multi_select_component.DropdownMultiSelectComponentNgFactory;

    ComponentRef _componentRefEditField = super.loader.loadNextToLocation(
        componentFactorySelect, super.viewContainerRefField);

    _componentRefEditField.instance.field = super.field;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }

  ComponentRef _addInputText() {
    ComponentFactory<input_text_component.InputTextComponent>
        componentFactoryInputText =
        input_text_component.InputTextComponentNgFactory;

    ComponentRef _componentRefEditField = super.loader.loadNextToLocation(
        componentFactoryInputText, super.viewContainerRefField);

    _componentRefEditField.instance.field = super.field;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }

  ComponentRef _addCheckBox() {
    ComponentFactory<checkbox_component.CheckboxComponent>
        componentFactoryCheckbox =
        checkbox_component.CheckboxComponentNgFactory;

    ComponentRef _componentRefEditField = super.loader.loadNextToLocation(
        componentFactoryCheckbox, super.viewContainerRefField);

    _componentRefEditField.instance.field = super.field;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }

  ComponentRef _addDatepicker() {
    ComponentFactory<datepicker_component.DatepickerComponent>
        componentFactoryCheckbox =
        datepicker_component.DatepickerComponentNgFactory;

    ComponentRef _componentRefEditField = super.loader.loadNextToLocation(
        componentFactoryCheckbox, super.viewContainerRefField);

    _componentRefEditField.instance.field = super.field;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }
}
