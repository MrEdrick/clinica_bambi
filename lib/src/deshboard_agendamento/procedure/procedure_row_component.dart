import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';

import '../../agendamento/procedure/procedure.dart';
import '../../agendamento/procedure/procedure_dao.dart';
import '../../agendamento/procedure/procedure_service.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/procedure/procedure_edit_component.template.dart'
    as procedure_edit;

@Component(
    selector: 'procedure_row_component',
    styleUrls: const [
      'procedure_row_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'procedure_row_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ModalComponent,
      MaterialButtonComponent,
    ])
class ProcedureRowComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  Procedure procedure;
  ProcedureService procedureService = new ProcedureService();

  bool showEditAgendamentoEditApp = false;
  bool showDeteleCertification = false;

  @Input()
  String procedureId;

  @Input()
  ComponentRef componentRef;

  @ViewChild('containerEditProcedure', read: ViewContainerRef)
  ViewContainerRef materialContainerEdit;

  ProcedureRowComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() async {
    procedure = await procedureService.getProcedureById(procedureId);
    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    procedureService.procedure = procedure;
    ComponentFactory<procedure_edit.ProcedureEditComponent>
        procedureEdit = procedure_edit.ProcedureEditComponentNgFactory;

    ComponentRef procedureEditComponent = _loader.loadNextToLocation(procedureEdit, materialContainerEdit);
    procedureEditComponent.instance.componentRef = procedureEditComponent;
  }

  void onDelete() {
    showDeteleCertification = true;
  }

  void delete() {
    new ProcedureDAO().delete(procedureId);   
    showDeteleCertification = false;
    componentRef.destroy();
  }

  void noDelete() {
    showDeteleCertification = false;
  }
}
