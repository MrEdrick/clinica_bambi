import 'dart:html';
import 'package:angular/angular.dart';
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

import 'agendamento/agendamento_filter_component.dart';
import 'dentist/dentist_filter_component.dart';
import 'procedure/procedure_filter_component.dart';
import 'requirement/requirement_filter_component.dart';

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
    AgendamentoFilterComponent,
    DentistFilterComponent,
    ProcedureFilterComponent,
    RequirementFilterComponent
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
  final UserService userService;
  
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  String filterApp;

  final Router _router;

  @ViewChild(AgendamentoFilterComponent)
  AgendamentoFilterComponent agendamentoFilterComponent;

  DeshboardComponent(this._router): userService = new UserService();

  @override
  void onActivate(_, RouterState current) async {
    try {
      if (new UserService().user == null) {
        _router.navigate(paths.login.toUrl());
      } else {
        agendamentoFilterComponent.onFilter();
      }
    } catch (e) {
      _router.navigate(paths.login.toUrl());
    }
  }

  void ngOnInit() { 
    if (new UserService().user == null)
      return;
      
  }

  void onClickMenuItem(String filter) {
    ElementList listFilters = querySelectorAll(".filter-app");

    for (Element filter in listFilters) {
      filter.style.display = "none";
    }   

    filterApp = filter;

    switch (filter) {
      case 'Agendamentos': 
        querySelector("agendamento-filter-app").style.display = "block";
        break;
      case 'Dentistas': 
        querySelector("dentist-filter-app").style.display = "block";
        break;
      case 'Procedimentos': 
        querySelector("procedure-filter-app").style.display = "block";
        break;
      case 'Requisitos': 
        querySelector("requirement-filter-app").style.display = "block";
        break;
    }
  
  }
}