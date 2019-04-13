import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../agendamento/consulta/consulta.dart';
import '../../agendamento/consulta/consulta_service.dart';
import 'agendamento_edit_component.dart';

@Component(
    selector: 'agendamento-card-app',
    styleUrls: const [
      'agendamento_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'agendamento_card_component.html',
    changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      AgendamentoEditComponent,
      ModalComponent,
    ])

class AgendamentoCardComponent{
  static String _appointmentSchedulerId;
  final Consulta _consulta;
  ConsultaService consultaService;

  bool showEditAgendamentoEditApp = false;

  String get appointmentSchedulerId => _appointmentSchedulerId;
  @Input()
  set appointmentSchedulerId(String appointmentSchedulerId) => _appointmentSchedulerId = appointmentSchedulerId; 

  AgendamentoCardComponent(): _consulta = new ConsultaService().getDentistByIdFromList(_appointmentSchedulerId);

  void onEdit() {
    querySelector('#editAgendamento').click();
    querySelector('#agendamento-edit-app').style.display = 'block';
  }

}
