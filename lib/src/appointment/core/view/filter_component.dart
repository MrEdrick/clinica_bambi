import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_button/material_fab.dart';

import '../../../route_paths.dart' as paths;
import '../../../appointment/user/user_service.dart';
import '../controller/service.dart';

import 'list_component_component.template.dart'
    as list_component;
import 'edit_component_component.template.dart'
    as edit_component;

@Component(
  selector: 'filter_component',
  templateUrl: 'filter_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [
    coreDirectives,
    materialInputDirectives,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialToggleComponent,
    MaterialFabComponent,
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class ProcedureFilterComponent implements OnActivate, OnInit {  
  ComponentRef componentRef;
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;
 
  final Router _router;

  @ViewChild('containerListProcedure', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  @ViewChild('containerEditProcedure', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  final Service service = new Service();

  ProcedureFilterComponent(this._router, this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    await onFilter();
  }

  @override
  void onActivate(_, RouterState current) async {
    try {
      if (new UserService().user != null) {
        onFilter();
      } else {
        _router.navigate(paths.login.toUrl());
      }
    } catch (e) {
      _router.navigate(paths.login.toUrl());
    }
  }

  Future<void> onFilter() async {
    componentRef?.destroy();

    service.clearAllLists();

    service.getAllAcives().then((onValue) {
      service.getListWithFilter();

      onLoad();
    });
  }

  void onLoad() {
    ComponentFactory<list_component.ListComponent> listComponentFactory =
        list_component.ListComponentNgFactory;

    ComponentRef listComponentRef =
        _loader.loadNextToLocation(listComponentFactory, materialContainerList);

    listComponentRef.instance.componentRef = listComponentRef;
    componentRef = listComponentRef;

    _changeDetectorRef.markForCheck();
  }

  void onAdd() {
    service.map.clear();
    ComponentFactory<edit_component.EditComponent> editComponentFactory =
        edit_component.EditComponentNgFactory;

    ComponentRef editComponentRef =
        _loader.loadNextToLocation(editComponentFactory, materialContainerAdd);
    editComponentRef.instance.componentRef = editComponentRef;
  }

  void onClear() {
    //description = '';

    //querySelector('#procedure-total-result-filter-text').setAttribute('value', '0');
    //querySelector('#procedure-total-result-filter-text').setInnerHtml('0');
  }
}
