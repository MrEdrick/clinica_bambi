import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import '../../agendamento/procedure/procedure.dart';
import '../../agendamento/procedure/procedure_service.dart';
import 'procedure_edit_component.dart';

@Component(
    selector: 'procedure-card-app',
    styleUrls: const [
      'procedure_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'procedure_card_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ProcedureEditComponent,
      ModalComponent,
    ])

class ProcedureCardComponent {
  Procedure _procedure;
  ProcedureService procedureService;

  bool showEditAgendamentoEditApp = false;

  Procedure get procedure => _procedure;
  @Input()
  set procedure(Procedure procedure) => _procedure = procedure; 

  ProcedureCardComponent();

  void onEdit() {
    procedureService = new ProcedureService();
    procedureService.procedure = procedure;
    querySelector('#editProcedure').click();
    querySelector('#procedure-edit-app').style.display = 'block';
  }
}
