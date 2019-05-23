import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_button/material_fab.dart';

import '../../appointment/user/user_service.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling_service.dart';
import '../../route_paths.dart' as paths;

import 'package:ClinicaBambi/src/auto_deshboard/auto_appointment_scheduling/auto_appointment_scheduling_list_component.template.dart'
    as auto_appointment_scheduling_list;
import 'package:ClinicaBambi/src/auto_deshboard/auto_appointment_scheduling/auto_appointment_scheduling_edit_component.template.dart'
    as auto_appointment_scheduling_edit;

@Component(
  selector: 'auto_appointment_scheduling_filter_component',
  templateUrl: 'auto_appointment_scheduling_filter_component.html',
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
  providers: const [materialProviders, windowBindings, popupBindings],
  styleUrls: const [
    'auto_appointment_scheduling_filter_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AutoAppointmentSchedulingFilterComponent implements OnActivate, OnInit {
  AutoAppointmentSchedulingService _autoAppointmentSchedulingService = new AutoAppointmentSchedulingService();
  ComponentRef componentRef;
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;
  final Router _router;

  String description;

  @ViewChild('containerListRequirement', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  @ViewChild('containerEditRequirement', read: ViewContainerRef)
  ViewContainerRef materialContainerAdd;

  AutoAppointmentSchedulingFilterComponent(
      this._router, this._loader, this._changeDetectorRef);

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

  void onFilter() {
    componentRef?.destroy();

    _autoAppointmentSchedulingService.clearAllAutoAppointmentSchedulingList();

    _autoAppointmentSchedulingService.getAllAutoAppointmentSchedulingAcives().then((onValue) {
      _autoAppointmentSchedulingService
          .getAutoAppointmentSchedulingListWithFilterFromList({"description": description});

      onLoad();
    });
  }

  void onLoad() {
    ComponentFactory<
            auto_appointment_scheduling_list.AppointmentSchedulingListComponent>
        appointmentSchedulingList = auto_appointment_scheduling_list.AppointmentSchedulingListComponentNgFactory;

    ComponentRef appointmentSchedulingListComponent =
        _loader.loadNextToLocation(appointmentSchedulingList, materialContainerList);

    appointmentSchedulingListComponent.instance.componentRef = appointmentSchedulingListComponent;
    componentRef = appointmentSchedulingListComponent;

    _changeDetectorRef.markForCheck();
  }

  void onAdd() {
    _autoAppointmentSchedulingService.autoAppointmentScheduling = null;
    ComponentFactory<auto_appointment_scheduling_edit.AutoAppointmentSchedulingEditComponent>
        autoAppointmentSchedulingEdit = auto_appointment_scheduling_edit.AutoAppointmentSchedulingEditComponentNgFactory;

    ComponentRef autoAppointmentSchedulingEditComponent =
        _loader.loadNextToLocation(autoAppointmentSchedulingEdit, materialContainerAdd);
    autoAppointmentSchedulingEditComponent.instance.componentRef = autoAppointmentSchedulingEditComponent;
  }

  void onClear() {
    description = '';

    querySelector('#auto-appointment-scheduling-total-result-filter-text')
        .setAttribute('value', '0');
    querySelector('#auto-appointment-scheduling-total-result-filter-text').setInnerHtml('0');
  }
}
