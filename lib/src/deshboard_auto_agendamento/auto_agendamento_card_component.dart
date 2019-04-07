import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../agendamento/appointment/appointment.dart';
import '../agendamento/appointment/appointment_service.dart';
import 'auto_agendamento_edit_component.dart';

@Component(
    selector: 'auto-agendamento-card-app',
    styleUrls: const [
      'auto_agendamento_card_component.scss.css',
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

class AutoAgendamentoCardComponent {
  Appointment _appointment;
  Appointment appointmentService;

  bool showEditAgendamentoEditApp = false;

  Appointment get appointment => _appointment;
  @Input()
  set appointment(Appointment appointment) => _appointment = appointment; 

  AutoAgendamentoCardComponent();

  void onEdit() {
    appointmentService = new AppointmentService();
    appointmentService.appointment = appointment;
    querySelector('#editAgendamento').click();
    querySelector('#auto-agendamento-edit-app').style.display = 'block';
  }
}
