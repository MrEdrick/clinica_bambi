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

import '../../agendamento/user/user_service.dart';
import '../../route_paths.dart' as paths;
import '../../agendamento/procedure/procedure_service.dart';

import 'package:ClinicaBambi/src/deshboard_agendamento/procedure/procedure_list_component.template.dart'
    as procedure_list;
import 'package:ClinicaBambi/src/deshboard_agendamento/procedure/procedure_edit_component.template.dart'
    as procedure_edit;

@Component(
  selector: 'procedure_filter_component',
  templateUrl: 'procedure_filter_component.html',
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
    'procedure_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class ProcedureFilterComponent implements OnActivate, OnInit {  
  ProcedureService _procedureService = new ProcedureService();
  ComponentRef componentRef;
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;
 
  final Router _router;

  String description;

  @ViewChild('containerListProcedure', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  @ViewChild('containerEditProcedure', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

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

    _procedureService.clearAllProcedureList();

    _procedureService.getAllProcedureAcives().then((onValue) {
      _procedureService.getProcedureListWithFilterFromList({"description": description});

      onLoad();
    });
  }

  void onLoad() {
    ComponentFactory<procedure_list.ProcedureListComponent> procedureList =
        procedure_list.ProcedureListComponentNgFactory;

    ComponentRef procedureListComponent =
        _loader.loadNextToLocation(procedureList, materialContainerList);

    procedureListComponent.instance.componentRef = procedureListComponent;
    componentRef = procedureListComponent;

    _changeDetectorRef.markForCheck();
  }

  void onAdd() {
    _procedureService.procedure = null;
    ComponentFactory<procedure_edit.ProcedureEditComponent> procedureEdit =
        procedure_edit.ProcedureEditComponentNgFactory;

    ComponentRef procedureEditComponent =
        _loader.loadNextToLocation(procedureEdit, materialContainerAdd);
    procedureEditComponent.instance.componentRef = procedureEditComponent;
  }

  void onClear() {
    description = '';

    querySelector('#procedure-total-result-filter-text').setAttribute('value', '0');
    querySelector('#procedure-total-result-filter-text').setInnerHtml('0');
  }
}
