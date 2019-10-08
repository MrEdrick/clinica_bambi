import 'package:angular/angular.dart';

import '../model/collection.dart';
import '../model/field.dart';
import '../model/constants.dart';
import '../view/edit/input_text_component.template.dart'
    as input_text_component;
import '../view/edit/select_component.template.dart' as select_component;
import '../view/edit/checkbox_component.template.dart' as checkbox_component;
import '../view/edit/expansion_panel_group_component.template.dart'
    as expansion_panel_group_component;

class FactoryField {
  Field _field;
  ComponentLoader _loader;
  ViewContainerRef _viewContainerRefEditField;
  List<Collection> _collectionListDependent;

  FactoryField(this._field, this._loader, this._viewContainerRefEditField,
      this._collectionListDependent);

  ComponentRef addEditField() {
    ComponentRef _componentRefEditField = null;
    
    if (_field.type.isForeignKey) {
      if (_field.type.foreignKeyType.isGuide) {
        _componentRefEditField = _addSelect();
      }
      if (_field.type.foreignKeyType.isDependent) {
        _componentRefEditField = _addExpasionPanelGroup();
      }
    } else {
      switch (_field.type.primaryType) {
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

    ComponentRef _componentRefEditField = _loader.loadNextToLocation(
        componentFactoryInputText, _viewContainerRefEditField);

    _componentRefEditField.instance.field = _field;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }

  ComponentRef _addCheckBox() {
    ComponentFactory<checkbox_component.CheckboxComponent>
        componentFactoryCheckbox =
        checkbox_component.CheckboxComponentNgFactory;

    ComponentRef _componentRefEditField = _loader.loadNextToLocation(
        componentFactoryCheckbox, _viewContainerRefEditField);

    _componentRefEditField.instance.field = _field;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }

  ComponentRef _addSelect() {
    ComponentFactory<select_component.SelectComponent> componentFactorySelect =
        select_component.SelectComponentNgFactory;

    ComponentRef _componentRefEditField = _loader.loadNextToLocation(
        componentFactorySelect, _viewContainerRefEditField);

    _componentRefEditField.instance.field = _field;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }

  ComponentRef _addExpasionPanelGroup() {
    ComponentFactory<
            expansion_panel_group_component.ExpasionPanelGroupComponent>
        componentFactoryExpasionPanelGroup =
        expansion_panel_group_component.ExpasionPanelGroupComponentNgFactory;

    ComponentRef _componentRefEditField = _loader.loadNextToLocation(
        componentFactoryExpasionPanelGroup, _viewContainerRefEditField);

    _componentRefEditField.instance.field = _field;
    _componentRefEditField.instance.collectionList = _collectionListDependent;
    _componentRefEditField.instance.componentRef = _componentRefEditField;

    return _componentRefEditField;
  }
}
