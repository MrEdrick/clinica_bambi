import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';

import '../../appointment/appointment_scheduling/appointment_scheduling.dart';
import '../../appointment/appointment_scheduling/appointment_scheduling_service.dart';
import '../../appointment/appointment_scheduling/appointment_scheduling_dao.dart';
import 'package:ClinicaBambi/src/deshboard_appointment/appointment_scheduling/appointment_scheduling_edit_component.template.dart'
    as appointment_scheduling_edit;

@Component(
    selector: 'appointment_scheduling_card_component',
    styleUrls: const [
      'appointment_scheduling_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'appointment_scheduling_card_component.html',
    changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialDialogComponent,
      ModalComponent,
    ])
class AppointmentSchedulingCardComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  final AppointmentSchedulingService appointmentSchedulingService = new AppointmentSchedulingService();
  AppointmentScheduling appointmentScheduling;

  bool showDeteleCertification = false;

  @Input()
  String appointmentSchedulingId;

  @Input()
  ComponentRef componentRef;

  @ViewChild('containerEditAppointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerEdit;

  AppointmentSchedulingCardComponent(
      this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    Map map = appointmentSchedulingService
        .getAppointmentSchedulingByIdFromList(appointmentSchedulingId);
        
    appointmentScheduling = await appointmentSchedulingService.turnMapInAppointmentScheduling(map);

    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    appointmentSchedulingService.appointmentScheduling = appointmentScheduling;
    ComponentFactory<appointment_scheduling_edit.AppointmentSchedulingEditComponent>
        appointmentSchedulingEdit = appointment_scheduling_edit.AppointmentSchedulingEditComponentNgFactory;

    ComponentRef appointmentSchedulingEditComponent = _loader.loadNextToLocation(appointmentSchedulingEdit, materialContainerEdit);
    appointmentSchedulingEditComponent.instance.componentRef = appointmentSchedulingEditComponent;
  }

  void onDelete() {
    showDeteleCertification = true;
  }

  void deleteAppointmentScheduling() {
    new AppointmentSchedulingDAO().delete(appointmentSchedulingId);   
    showDeteleCertification = false;
    componentRef.destroy();
  }

  void noDeleteAppointmentScheduling() {
    showDeteleCertification = false;
  }
}
