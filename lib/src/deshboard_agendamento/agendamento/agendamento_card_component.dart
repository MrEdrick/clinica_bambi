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
import '../../agendamento/consulta/appointment_scheduling_dao.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/agendamento/agendamento_edit_component.template.dart'
    as agendamento_edit;

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
      ModalComponent,
    ])
class AgendamentoCardComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  Consulta consulta;

  bool showEditAgendamentoEditApp = false;
  bool showDeteleCertification = false;

  @Input()
  String appointmentSchedulerId;

  @ViewChild('containerEditAgendamento', read: ViewContainerRef)
  ViewContainerRef materialContainerEdit;

  AgendamentoCardComponent(
      this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    ConsultaService consultaService = new ConsultaService();
    Map map = consultaService
        .getAppointmentSchedulingByIdFromList(appointmentSchedulerId);
    consulta = await consultaService.turnMapInConsulta(map);
    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    new ConsultaService().consulta = consulta;
    ComponentFactory<agendamento_edit.AgendamentoEditComponent>
        agendamentoEdit = agendamento_edit.AgendamentoEditComponentNgFactory;

    ComponentRef agendamentoEditComponent = _loader.loadNextToLocation(agendamentoEdit, materialContainerEdit);
    agendamentoEditComponent.instance.componentRef = agendamentoEditComponent;
  }

  void onDelete() {
    showDeteleCertification = true;
  }

  void deleteConsulta() {
    new AppointmentSchedulingDAO().delete(appointmentSchedulerId);   
    showDeteleCertification = false;
    OnDestroy;
  }

  void noDeleteConsulta() {
    showDeteleCertification = false;
  }
}
