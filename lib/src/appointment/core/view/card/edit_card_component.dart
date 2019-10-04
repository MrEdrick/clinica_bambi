import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import '../../controller/service.dart';
import '../../../../appointment/user/user_service.dart';

import '../../model/collection.dart';
import '../../model/field.dart';
import '../edit/input_text_component.template.dart' as input_text_component;
import '../edit/select_component.template.dart' as select_component;
import '../edit/checkbox_component.template.dart' as checkbox_component;

@Component(
    selector: 'edit-card-app',
    styleUrls: const [
      'edit_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'edit_card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
    ])
class EditCardComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  final List<ComponentRef> listComponentRefEditField = new List<ComponentRef>();

  final Service service = new Service();
  final UserService userService = new UserService();

  @Input()
  ComponentRef componentRef;

  @Input()
  Collection collection;

  @ViewChild('viewContainerRefEditField', read: ViewContainerRef)
  ViewContainerRef viewContainerRefEditField;

  @ViewChild('viewContainerRefModal', read: ViewContainerRef)
  ViewContainerRef viewContainerRefModal;

  EditCardComponent(this._changeDetectorRef, this._loader);

  void onEdit() {
    if (service.map.isEmpty) {}
  }

  void ngOnInit() async {
    if (userService.user == null) return;

    listComponentRefEditField.clear();

    collection.fieldList.forEach((field) {
      if (field.type == "String") {
        addInputText(field);
      }
      if (field.type == "Boolean") {
        addCheckBox(field);
      }
      if (field.type == "Key") {
        addSelect(field);
      }
    });

    _changeDetectorRef.markForCheck();

    onEdit();

    _changeDetectorRef.markForCheck();
  }

  void addInputText(Field field) {
    ComponentFactory<input_text_component.InputTextComponent>
        componentFactoryInputText =
        input_text_component.InputTextComponentNgFactory;

    listComponentRefEditField.add(_loader.loadNextToLocation(
        componentFactoryInputText, viewContainerRefEditField));

    listComponentRefEditField.last.instance.field = field;
    listComponentRefEditField.last.instance.componentRef =
        listComponentRefEditField.last;
  }

  void addCheckBox(Field field) {
    ComponentFactory<checkbox_component.CheckboxComponent>
        componentFactoryCheckbox =
        checkbox_component.CheckboxComponentNgFactory;

    listComponentRefEditField.add(_loader.loadNextToLocation(
        componentFactoryCheckbox, viewContainerRefEditField));

    listComponentRefEditField.last.instance.field = field;
    listComponentRefEditField.last.instance.componentRef =
        listComponentRefEditField.last;
  }

  void addSelect(Field field) {
    ComponentFactory<select_component.SelectComponent> componentFactorySelect =
        select_component.SelectComponentNgFactory;

    listComponentRefEditField.add(_loader.loadNextToLocation(
        componentFactorySelect, viewContainerRefEditField));

    listComponentRefEditField.last.instance.field = field;
    listComponentRefEditField.last.instance.componentRef =
        listComponentRefEditField.last;
  }

  void onClose() {
    service.map.clear();

    componentRef.destroy();
  }

  bool asserts() {
    return true;
  }

  void onAssertsSave() {
    onSave();
  }

  void onNoSave() {}

  void onSave() async {
    _changeDetectorRef.markForCheck();
  }
}
