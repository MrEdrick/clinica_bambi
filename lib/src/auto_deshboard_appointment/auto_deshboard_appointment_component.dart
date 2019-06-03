import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_button/material_fab.dart';
import '../appointment/user/user.dart';
import '../appointment/user/user_service.dart';
import '../route_paths.dart' as paths;

import '../appointment/patient_account/patient_account_service.dart';
import 'package:ClinicaBambi/src/auto_deshboard_appointment/auto_appointment_scheduling/auto_appointment_scheduling_filter_component.template.dart'
    as auto_appointment_scheduling_filter;

@Component(
  selector: 'auto_deshboard_appointment_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'auto_deshboard_appointment_component.html',
  directives: const [
    coreDirectives,
    materialInputDirectives,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialFabComponent
  ],
  providers: const [materialProviders, windowBindings, popupBindings],
  styleUrls: const [
    'auto_deshboard_appointment_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AutoDeshboardAppointmentComponent implements OnActivate, OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  ComponentRef componentRef;

  User user;

  bool useItemRenderer = false;
  bool useOptionGroup = false;

  final Router _router;

  @ViewChild('materialContentFilter', read: ViewContainerRef)
  ViewContainerRef materialContentFilter;

  AutoDeshboardAppointmentComponent(
      this._router, this._loader, this._changeDetectorRef);

  @override
  void onActivate(_, RouterState current) async {}

  Future<NavigationResult> goAutoHome() =>
      _router.navigate(paths.deshboard.toUrl());

  void ngOnInit() {
    if ((new UserService().user == null) ||
        (new PatientAccountService().patientAccount == null)) {
      return;
    } else {
      loadAutoAppointmentSchedulingFilter();
    }

    _changeDetectorRef.markForCheck();
  }

  void onClose() {
    goAutoHome();
    onClose();
  }

  void loadAutoAppointmentSchedulingFilter() {
    ComponentFactory<
            auto_appointment_scheduling_filter
                .AutoAppointmentSchedulingFilterComponent>
        autoAppointmentSchedulingFilter = auto_appointment_scheduling_filter
            .AutoAppointmentSchedulingFilterComponentNgFactory;
    componentRef = _loader.loadNextToLocation(
        autoAppointmentSchedulingFilter, materialContentFilter);
  }
}
