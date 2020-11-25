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
import '../route_paths.dart' as paths;

import '../appointment/user/user_service.dart';
import '../appointment/generic/generic_service.dart'; 

import 'package:ClinicaBambi/src/deshboard_appointment/appointment_scheduling/appointment_scheduling_filter_component.template.dart'
    as appointment_scheduling_filter;
import 'package:ClinicaBambi/src/deshboard_appointment/dentist/dentist_filter_component.template.dart'
    as dentist_filter;
import 'package:ClinicaBambi/src/deshboard_appointment/procedure/procedure_filter_component.template.dart'
    as procedure_filter;
import 'package:ClinicaBambi/src/deshboard_appointment/requirement/requirement_filter_component.template.dart'
    as requirement_filter;

@Component(
  selector: 'deshboard_appointment_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'deshboard_appointment_component.html',
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
    'deshboard_appointment_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DeshboardAppointmentComponent implements OnActivate, OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  ComponentRef componentRef;

  final UserService userService;

  final Router _router;

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  String filterApp;

  @ViewChild('materialContentFilter', read: ViewContainerRef)
  ViewContainerRef materialContentFilter;

  DeshboardAppointmentComponent(this._router, this._loader, this._changeDetectorRef) //, this._location
      : userService = new UserService();

  @override
  void onActivate(_, RouterState current) async {
    try {
      if (new UserService().user == null) {
        _router.navigate(paths.login.toUrl());
      } else {
        //querySelector('#wh-widget-send-button').style.display = 'none';
        loadAppointmentSchedulingFilter();
        _changeDetectorRef.markForCheck();
      }
    } catch (e) {
      _router.navigate(paths.login.toUrl());
    }
  }

  void ngOnInit() async {
    if (new UserService().user == null) return;
  }

  void loadAppointmentSchedulingFilter() {
    ComponentFactory<appointment_scheduling_filter.AppointmentSchedulingFilterComponent>
        appointment_schedulingFilter =
        appointment_scheduling_filter.AppointmentSchedulingFilterComponentNgFactory;
    componentRef =
        _loader.loadNextToLocation(appointment_schedulingFilter, materialContentFilter);
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

    new GenericService().clearAllServicesLists();
    
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

    _changeDetectorRef.markForCheck();
  }
}
