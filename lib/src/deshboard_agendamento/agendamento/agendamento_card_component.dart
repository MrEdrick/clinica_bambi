import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';

import '../../agendamento/consulta/consulta.dart';
import '../../agendamento/consulta/consulta_service.dart';
import 'agendamento_edit_component.dart';

@Component(
    selector: 'agendamento_card_component',
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
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialDialogComponent,
      //AgendamentoEditComponent,
      ModalComponent,
    ])
class AgendamentoCardComponent implements OnInit {
  ChangeDetectorRef _changeDetectorRef; 
  Consulta consulta;

  bool showEditAgendamentoEditApp = false;
  bool showDeteleCertification = false;

  @Input()
  String appointmentSchedulerId;

  AgendamentoCardComponent(this._changeDetectorRef);

  void ngOnInit() async {
    ConsultaService consultaService = new ConsultaService();
    Map map = consultaService
        .getAppointmentSchedulingByIdFromList(appointmentSchedulerId);
    consulta = await consultaService.turnMapInConsulta(map);
    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    //querySelector('#editAgendamento').click();
    //querySelector('#agendamento-edit-app').style.display = 'block';
  }

  void onDelete() {
    showDeteleCertification = true;
  }

  void deleteConsulta() {
    //FireStoreApp _fireStoreApp =
    //    new FireStoreApp(APPOINTMENT_SCHEDULING_COLLECTION);
    //_fireStoreApp.deleteItem(listAppointmentSchedulingId[deleteIndex]);
    //_fireStoreApp.FireStoreOffLine();
    //listAppointmentSchedulingId.removeAt(deleteIndex);
    showDeteleCertification = false;
  }

  void noDeleteConsulta() {
    showDeteleCertification = false;
  }
}
