import 'package:angular/angular.dart';
import '../model/field.dart';
import '../model/constants.dart';
import '../view/edit/input_text_component.template.dart'
    as input_text_component;
import '../view/edit/select_component.template.dart' as select_component;
import '../view/edit/checkbox_component.template.dart' as checkbox_component;

class FactoryField {
  Field _field;
  ComponentLoader _loader;
  ViewContainerRef _viewContainerRefEditField;

  FactoryField(this._field, this._loader, this._viewContainerRefEditField);

  List<ComponentRef> addField() {
    if (_field.type == FIELD_TYPE_STRING) {
      return addInputText();
    }
    if (_field.type == FIELD_TYPE_BOOLEAN) {
      return addCheckBox();
    }
    if (_field.type == FIELD_TYPE_FOREIGN_KEY) {
      return addSelect();
    }
  }

  List<ComponentRef> _addInputText() {
    List<ComponentRef> _listComponentRefEditField = new List<ComponentRef>();

    ComponentFactory<input_text_component.InputTextComponent>
        componentFactoryInputText =
        input_text_component.InputTextComponentNgFactory;

    _listComponentRefEditField.add(_loader.loadNextToLocation(
        componentFactoryInputText, _viewContainerRefEditField));

    _listComponentRefEditField.last.instance.field = _field;
    _listComponentRefEditField.last.instance.componentRef =
        _listComponentRefEditField.last;

    return _listComponentRefEditField;
  }

  List<ComponentRef> _addCheckBox() {
    List<ComponentRef> _listComponentRefEditField = new List<ComponentRef>();

    ComponentFactory<checkbox_component.CheckboxComponent>
        componentFactoryCheckbox =
        checkbox_component.CheckboxComponentNgFactory;

    _listComponentRefEditField.add(_loader.loadNextToLocation(
        componentFactoryCheckbox, _viewContainerRefEditField));

    _listComponentRefEditField.last.instance.field = _field;
    _listComponentRefEditField.last.instance.componentRef =
        _listComponentRefEditField.last;

    return _listComponentRefEditField;
  }

  List<ComponentRef> _addSelect() {
    List<ComponentRef> _listComponentRefEditField = new List<ComponentRef>();

    ComponentFactory<select_component.SelectComponent> componentFactorySelect =
        select_component.SelectComponentNgFactory;

    _listComponentRefEditField.add(_loader.loadNextToLocation(
        componentFactorySelect, _viewContainerRefEditField));

    _listComponentRefEditField.last.instance.field = _field;
    _listComponentRefEditField.last.instance.componentRef =
        _listComponentRefEditField.last;

    return _listComponentRefEditField;
  }
}
