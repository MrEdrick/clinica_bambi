import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../controller/service/service.dart';
import '../../model/collection.dart';
import '../../controller/factory/factory_label_field.dart';

import 'edit_card_component_component.template.dart' as edit_card_component;

@Component(
    selector: 'card-component',
    styleUrls: const [
      'card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ModalComponent,
    ])
class CardComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;
  final Service service = new Service();

  @ViewChild('viewContainerRefLabel', read: ViewContainerRef)
  ViewContainerRef viewContainerRefLabel;

  @ViewChild('viewContainerRefEdit', read: ViewContainerRef)
  ViewContainerRef viewContainerRefEdit;

  @Input()
  ComponentRef componentRef;

  @Input()
  Collection collection;

  Map _map;
  Map get map => _map;
  @Input()
  set map(Map map) => _map = map;

  bool showEditAgendamentoEditApp = false;

  List<ComponentRef> listComponentRefLabelField;
  CardComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() {
    listComponentRefLabelField.clear();

    collection.fieldList.forEach((field) {
      listComponentRefLabelField.add(
          new FactoryLabelField(field, _loader, viewContainerRefLabel)
              .addField());
    });

    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    service.map = map;

    ComponentFactory<edit_card_component.EditCardComponent> editComponent =
        edit_card_component.EditCardComponentNgFactory;

    ComponentRef editComponentRef =
        _loader.loadNextToLocation(editComponent, viewContainerRefEdit);

    editComponentRef.instance.componentRef = editComponentRef;

    _changeDetectorRef.markForCheck();
  }
}
