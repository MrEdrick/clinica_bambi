import 'dart:async';
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
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/material_button/material_fab.dart';
import '../appointment/user/user.dart';
import '../appointment/user/user_service.dart';
import '../route_paths.dart' as paths;
import 'package:intl/intl.dart';

import '../appointment/shift/shift.dart';
import '../appointment/shift/shift_service.dart';
import '../appointment/shift/shift_selection_options.dart';

import '../appointment/dentist/dentist.dart';
import '../appointment/dentist/dentistUI.dart';
import '../appointment/dentist/dentist_service.dart';
import '../appointment/dentist/dentist_selection_options.dart';

import 'auto_appointment_scheduling/auto_appointment_scheduling_filter_component.dart';

import '../appointment/appointment_scheduling/appointment_scheduling_service.dart';

@Component(
  selector: 'auto_deshboard_appointment_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'auto_deshboard_appointment_component.html',
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
    MaterialFabComponent
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'auto_deshboard_appointment_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AutoDeshboardAppointmentComponent implements OnActivate, OnInit {
  AppointmentSchedulingService _appointmentSchedulingService = new AppointmentSchedulingService();

  AppointmentSchedulingService get appointmentSchedulingService => _appointmentSchedulingService;
  set appointmentSchedulingService(AppointmentSchedulingService appointmentSchedulingService) => _appointmentSchedulingService = appointmentSchedulingService;

  User user;
  
  bool useItemRenderer = false;
  bool useOptionGroup = false;

  final Router _router;

  AutoDeshboardAppointmentComponent(this._router);

  @override
  void onActivate(_, RouterState current) async {
  }

  Future<NavigationResult>  goAutoHome() => _router.navigate(
    paths.deshboard.toUrl()
  );

  void ngOnInit() { 
    if (new UserService().user == null)
      return;
  }

  void onClose() {
    goAutoHome();
  }

}
