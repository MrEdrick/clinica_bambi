import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';

import '../../controller/service/service.dart';
import '../../model/collection.dart';
import '../../controller/factory/factory_edit_field.dart';

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

  @Input()
  ComponentRef componentRef;

  @Input()
  Collection collection;

  @Input()
  List<Collection> _collectionListDependent;

  @ViewChild('viewContainerRefEditField', read: ViewContainerRef)
  ViewContainerRef viewContainerRefEditField;

  @ViewChild('viewContainerRefModal', read: ViewContainerRef)
  ViewContainerRef viewContainerRefModal;

  EditCardComponent(this._changeDetectorRef, this._loader);

  void onEdit() {
    if (service.map.isEmpty) {}
  }

  void ngOnInit() async {
    listComponentRefEditField.clear();

    collection.fieldList.forEach((field) {
      listComponentRefEditField.add(new FactoryEditField(field, _loader,
              viewContainerRefEditField, _collectionListDependent)
          .addField());
    });

    onEdit();

    _changeDetectorRef.markForCheck();
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
