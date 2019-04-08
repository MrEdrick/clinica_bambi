import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../agendamento/consulta/consulta.dart';
import '../../agendamento/consulta/consulta_service.dart';
import 'agendamento_edit_component.dart';

@Component(
    selector: 'dentist-card-app',
    styleUrls: const [
      'dentist_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'dentist_card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      DentistEditComponent,
      ModalComponent,
    ])

class DentistCardComponent {
  Consulta _consulta;
  ConsultaService consultaService;

  bool showEditAgendamentoEditApp = false;

  Consulta get consulta => _consulta;
  @Input()
  set consulta(Consulta consulta) => _consulta = consulta; 

  AgendamentoCardComponent();

  void onEdit() {
    consultaService = new ConsultaService();
    consultaService.consulta = consulta;
    querySelector('#editAgendamento').click();
    querySelector('#agendamento-edit-app').style.display = 'block';
  }
}
