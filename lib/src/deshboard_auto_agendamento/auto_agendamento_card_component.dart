import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../agendamento/consulta/consulta.dart';
import '../agendamento/consulta/consulta_service.dart';
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
  Consulta _consulta;
  Consulta consultaService;

  bool showEditAgendamentoEditApp = false;

  Consulta get consulta => _consulta;
  @Input()
  set consulta(Consulta consulta) => _consulta = consulta; 

  AutoAgendamentoCardComponent();

  void onEdit() {
    consultaService = new ConsultaService();
    consultaService.consulta = consulta;
    querySelector('#editAgendamento').click();
    querySelector('#auto-agendamento-edit-app').style.display = 'block';
  }
}
