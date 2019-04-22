import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';

import '../../agendamento/requirement/requirement.dart';
import '../../agendamento/requirement/requirement_service.dart';

@Component(
    selector: 'requirement_row_component',
    styleUrls: const [
      'requirement_row_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'requirement_row_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ModalComponent,
      MaterialButtonComponent,
    ])
class RequirementRowComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  Requirement requirement;
  RequirementService requirementService = new RequirementService();

  @Input()
  String procedureId;

  @Input()
  ComponentRef componentRef;

  RequirementRowComponent(this._changeDetectorRef);

  void ngOnInit() async {
    requirement = await requirementService.getProcedureById(procedureId);
    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    //dentistService = new DentistService();
    //dentistService.dentist = dentist;
  }
}
