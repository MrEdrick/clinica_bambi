import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../appointment/appointment_scheduling/appointment_scheduling.dart';
import '../../appointment/appointment_scheduling/appointment_scheduling_service.dart';
import 'auto_appointment_scheduling_edit_component.dart';

@Component(
    selector: 'auto_appointment_scheduling_card_component',
    styleUrls: const [
      'auto_appointment_scheduling_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'auto_agendamento_card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      AutoAgendamentoEditComponent,
      ModalComponent,
    ])

class AutoAppointmentSchedulingCardComponent {
  AppointmentScheduling _appointmentScheduling;
  AppointmentSchedulingService appointmentSchedulingService;

  bool showEditAppointmentSchedulingEditApp = false;

  AppointmentScheduling get appointmentScheduling => _appointmentScheduling;
  @Input()
  set appointmentScheduling(AppointmentScheduling appointmentScheduling) => _appointmentScheduling = appointmentScheduling; 

  AutoAppointmentSchedulingCardComponent();

  void onEdit() {
    appointmentSchedulingService = new AppointmentSchedulingService();
    appointmentSchedulingService.appointmentScheduling = appointmentScheduling;
  }
}
