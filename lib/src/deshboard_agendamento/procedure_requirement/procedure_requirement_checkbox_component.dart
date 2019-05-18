import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import '../../agendamento/user/user_service.dart';

import '../../agendamento/procedure_requirement/procedure_requirement.dart';
import '../../agendamento/procedure_requirement/procedure_requirement_service.dart';

@Component(
    selector: 'procedure_requirement_checkbox_component',
    styleUrls: const [
      'procedure_requirement_checkbox_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'procedure_requirement_checkbox_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialCheckboxComponent,
    ])
class ProcedureRequirementCheckboxComponent implements OnInit {
  final ProcedureRequirementService procedureRequirementService = new ProcedureRequirementService();
  final ChangeDetectorRef _changeDetectorRef;

  String procedureRequirementId = "";
  
  @Input()
  String procedureId;

  @Input()
  String requirementId;

  @Input()
  String requirement;

  bool checked = false;

  ProcedureRequirementCheckboxComponent(this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;
    
    if ((procedureId != "") && (procedureId != null)) {
      (await procedureRequirementService
          .getOneProcedureRequirementByFilterFromList(
              {"procedureId": procedureId,
               "requirementId": requirementId}));
      if (procedureRequirementService
                  .procedureRequirementListByProcedureIdRequirementId[
              procedureId + requirementId] ==
          null) {
        procedureRequirementId = "";
      } else {
        procedureRequirementId =
            procedureRequirementService
                  .procedureRequirementListByProcedureIdRequirementId[
                    procedureId + requirementId]
                .id;
      }
    } else {
      procedureRequirementId = "";
      procedureRequirementService
              .procedureRequirement =
          new ProcedureRequirement(
              "", procedureId, requirementId);
    }

    checked = procedureRequirementId != "";

    _changeDetectorRef.markForCheck();
  }

  void onCheckedChange() {
    if (checked) {
      if (procedureRequirementService
                  .procedureRequirementListByProcedureIdRequirementId[
              procedureId + requirementId] ==
          null) {
        procedureRequirementService
                  .procedureRequirementListByProcedureIdRequirementId[
            procedureId + requirementId] = new ProcedureRequirement(
            "", procedureId, requirementId);
      }

      procedureRequirementService
                  .procedureRequirementListByProcedureIdRequirementId[
              procedureId + requirementId]
          .procedureId = procedureId;

      procedureRequirementService
                  .procedureRequirementListByProcedureIdRequirementId[
              procedureId + requirementId]
          .requirementId = requirementId;
    } else {
      if (procedureRequirementService
                  .procedureRequirementListByProcedureIdRequirementId[
              procedureId + requirementId] !=
          null) {
        procedureRequirementService
                  .procedureRequirementListByProcedureIdRequirementId[
                procedureId + requirementId]
            .procedureId = "";

        procedureRequirementService
                  .procedureRequirementListByProcedureIdRequirementId[
                procedureId + requirementId]
            .requirementId = "";
      }
    }

    _changeDetectorRef.markForCheck();
  }
}
