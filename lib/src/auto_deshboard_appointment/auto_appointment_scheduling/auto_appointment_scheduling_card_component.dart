import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling.dart';
import '../../appointment/auto_appointment_scheduling/auto_appointment_scheduling_service.dart';
import 'package:ClinicaBambi/src/auto_deshboard_appointment/auto_appointment_scheduling/auto_appointment_scheduling_edit_component.template.dart'
    as auto_appointment_scheduling_edit;

@Component(
    selector: 'auto_appointment_scheduling_card_component',
    styleUrls: const [
      'auto_appointment_scheduling_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'auto_appointment_scheduling_card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ModalComponent,
    ])
class AutoAppointmentSchedulingCardComponent {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  final AutoAppointmentSchedulingService autoAppointmentSchedulingService =
      new AutoAppointmentSchedulingService();
  AutoAppointmentScheduling autoAppointmentScheduling;

  bool showEditAppointmentSchedulingEditApp = false;

  @Input()
  String autoAppointmentSchedulerId;

  @Input()
  ComponentRef componentRef;

  @ViewChild('containerEditAutoAppointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerEdit;

  AutoAppointmentSchedulingCardComponent(this._changeDetectorRef, this._loader);

  void onEdit() {
    autoAppointmentSchedulingService.autoAppointmentScheduling =
        autoAppointmentScheduling;
    ComponentFactory<
            auto_appointment_scheduling_edit
                .AutoAppointmentSchedulingEditComponent>
        autoAppointmentSchedulingEdit = auto_appointment_scheduling_edit
            .AutoAppointmentSchedulingEditComponentNgFactory;

    ComponentRef autoAppointmentSchedulingEditComponent =
        _loader.loadNextToLocation(
            autoAppointmentSchedulingEdit, materialContainerEdit);
    autoAppointmentSchedulingEditComponent.instance.componentRef =
        autoAppointmentSchedulingEditComponent;
  }
}
