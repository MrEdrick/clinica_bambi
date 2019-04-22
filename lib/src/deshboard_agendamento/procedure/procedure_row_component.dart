import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';

import '../../agendamento/procedure/procedure.dart';
import '../../agendamento/procedure/procedure_service.dart';

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
  final ChangeDetectorRef _changeDetectorRef;
  Procedure procedure;
  ProcedureService procedureService = new ProcedureService();

  @Input()
  String procedureId;

  @Input()
  ComponentRef componentRef;

  ProcedureRowComponent(this._changeDetectorRef);

  void ngOnInit() async {
    procedure = await procedureService.getProcedureById(procedureId);
    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    //dentistService = new DentistService();
    //dentistService.dentist = dentist;
  }
}