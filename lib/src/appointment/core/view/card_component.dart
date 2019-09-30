import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../controller/service.dart';

import 'edit_component_component.template.dart'
    as edit_component;

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

class CardComponent {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;

  @ViewChild('appLabel', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  Map _map;
  Service service;

  bool showEditAgendamentoEditApp = false;

  Map get map => _map;
  @Input()
  set map(Map map) => _map = map; 

  CardComponent(this._changeDetectorRef, this._loader);

  void onEdit() {
    service = new Service();
    service.map = map;

    ComponentFactory<edit_component.ProcedureListComponent> editComponent =
        edit_component.ProcedureListComponentNgFactory;

    ComponentRef editComponentRef =
        _loader.loadNextToLocation(editComponent, materialContainerList);

    editComponentRef.instance.componentRef = editComponentRef;

    _changeDetectorRef.markForCheck();
  }
}
