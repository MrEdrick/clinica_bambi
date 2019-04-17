import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import '../agendamento/user/user_service.dart';
import '../route_paths.dart' as paths;

import 'package:ClinicaBambi/src/deshboard_agendamento/agendamento/agendamento_filter_component.template.dart'
    as agendamento_filter;
import 'package:ClinicaBambi/src/deshboard_agendamento/dentist/dentist_filter_component.template.dart'
    as dentist_filter;
import 'package:ClinicaBambi/src/deshboard_agendamento/procedure/procedure_filter_component.template.dart'
    as procedure_filter;
import 'package:ClinicaBambi/src/deshboard_agendamento/requirement/requirement_filter_component.template.dart'
    as requirement_filter;

@Component(
  selector: 'deshboard-app',
  templateUrl: 'deshboard_component.html',
  directives: const [
    coreDirectives,
    materialInputDirectives,
    NgFor,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialToggleComponent,
    MaterialDatepickerComponent,
    DateRangeInputComponent,
    MaterialDropdownSelectComponent,
    MultiDropdownSelectValueAccessor,
    MaterialFabComponent,
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'deshboard_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DeshboardComponent implements OnActivate, OnInit {
  final ComponentLoader _loader;
  ComponentRef componentRef;

  final UserService userService;

  final Router _router;

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  String filterApp;

  @ViewChild('materialContentFilter', read: ViewContainerRef)
  ViewContainerRef materialContentFilter;

  DeshboardComponent(this._router, this._loader) //, this._location
      : userService = new UserService();

  @override
  void onActivate(_, RouterState current) async {
    try {
      if (new UserService().user == null) {
        _router.navigate(paths.login.toUrl());
      } else {
        querySelector('#wh-widget-send-button').style.display = 'none';
        loadAppointmentSchedulingFilter();
      }
    } catch (e) {
      _router.navigate(paths.login.toUrl());
    }
  }

  void ngOnInit() async {
    if (new UserService().user == null) return;
  }

  void loadAppointmentSchedulingFilter() {
    ComponentFactory<agendamento_filter.AgendamentoFilterComponent>
        agendamentoFilter =
        agendamento_filter.AgendamentoFilterComponentNgFactory;
    componentRef =
        _loader.loadNextToLocation(agendamentoFilter, materialContentFilter);
  }

  void loadDentistFilter() {
    ComponentFactory<dentist_filter.DentistFilterComponent>
        dentist_Filter =
        dentist_filter.DentistFilterComponentNgFactory;
    componentRef =
        _loader.loadNextToLocation(dentist_Filter, materialContentFilter);
  }

  void loadProcedureFilter() {
    ComponentFactory<procedure_filter.ProcedureFilterComponent>
        procedureFilter =
        procedure_filter.ProcedureFilterComponentNgFactory;
    componentRef =
        _loader.loadNextToLocation(procedureFilter, materialContentFilter);
  }

  void loadRequirementFilter() {
    ComponentFactory<requirement_filter.RequirementFilterComponent>
        requirementFilter =
        requirement_filter.RequirementFilterComponentNgFactory;
    componentRef =
        _loader.loadNextToLocation(requirementFilter, materialContentFilter);
  }


  void onClickMenuItem(String filter) {
    componentRef.destroy();

    switch (filter) {
      case 'Agendamentos':
        loadAppointmentSchedulingFilter();
        break;
      case 'Dentistas':
        loadDentistFilter();
        break;
      case 'Procedimentos':
        loadProcedureFilter();
        break;
      case 'Requisitos':
        loadRequirementFilter();
        break;
    }
  }
}
