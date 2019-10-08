import 'package:angular/angular.dart';

import 'factory_field.dart';
import '../model/collection.dart';
import '../model/field.dart';
import '../model/constants.dart';

import '../view/edit/input_text_component.template.dart'
    as input_text_component;
import '../view/edit/select_component.template.dart' as select_component;
import '../view/edit/checkbox_component.template.dart' as checkbox_component;
import '../view/edit/expansion_panel_group_component.template.dart'
    as expansion_panel_group_component;

class FactoryEditField extends FactoryField {
  FactoryEditField(
      Field field,
      ComponentLoader loader,
      ViewContainerRef viewContainerRefField,
      List<Collection> collectionListDependent)
      : super(field, loader, viewContainerRefField, collectionListDependent);

  ComponentRef addField() {
    ComponentRef _componentRefEditField = null;

    if (super.field.type.isForeignKey) {
      if (super.field.type.foreignKeyType.isGuide) {
        _componentRefEditField = _addSelect();
      }
      if (super.field.type.foreignKeyType.isDependent) {
        _componentRefEditField = _addExpasionPanelGroup();
      }
    } else {
      switch (super.field.type.primaryType) {
        case FIELD_TYPE_STRING:
          {
            _componentRefEditField = _addInputText();
          }
          break;

        case FIELD_TYPE_BOOLEAN:
          {
            _componentRefEditField = _addCheckBox();
          }
          break;
      }
    }

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

  ComponentRef _addSelect() {
    ComponentFactory<select_component.SelectComponent> componentFactorySelect =
        select_component.SelectComponentNgFactory;

    ComponentRef _componentRefEditField = super.loader.loadNextToLocation(
        componentFactorySelect, super.viewContainerRefField);

    _componentRefEditField.instance.field = super.field;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }

  ComponentRef _addExpasionPanelGroup() {
    ComponentFactory<
            expansion_panel_group_component.ExpasionPanelGroupComponent>
        componentFactoryExpasionPanelGroup =
        expansion_panel_group_component.ExpasionPanelGroupComponentNgFactory;

    ComponentRef _componentRefEditField = super.loader.loadNextToLocation(
        componentFactoryExpasionPanelGroup, super.viewContainerRefField);

    _componentRefEditField.instance.field = super.field;
    _componentRefEditField.instance.collectionList =
        super.collectionListDependent;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }
}
