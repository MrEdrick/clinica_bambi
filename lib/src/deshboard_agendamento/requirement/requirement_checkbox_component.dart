import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import '../../agendamento/user/user_service.dart';

import '../../agendamento/requirement/requirement.dart';
import '../../agendamento/requirement/requirement_service.dart';

@Component(
    selector: 'requirement_checkbox_component',
    styleUrls: const [
      'requirement_checkbox_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'requirement_checkbox_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialCheckboxComponent,
    ])
class RequirementCheckboxComponent implements OnInit {
  final RequirementService requirementService = new RequirementService();
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  String procedureId;

  @Input()
  String requirementId;

  @Input()
  String requirement;

  bool checked = false;

  RequirementCheckboxComponent(this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    if ((procedureId != "") && (procedureId != null)) {
      (await requerimentService
          .getOneDentistProcedureByDayOfWeekByShiftByFilterFromList(
              {"procedureId": procedureId}));
      if (dentistProcedureByDayOfWeekByShiftService
                  .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
              dentistProcedureByDayOfWeekId + shiftId] ==
          null) {
        dentistProcedureByDayOfWeekByShiftId = "";
      } else {
        dentistProcedureByDayOfWeekByShiftId =
            dentistProcedureByDayOfWeekByShiftService
                .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
                    dentistProcedureByDayOfWeekId + shiftId]
                .id;
      }
    } else {
      dentistProcedureByDayOfWeekByShiftId = "";
      dentistProcedureByDayOfWeekByShiftService
              .dentistProcedureByDayOfWeekByShift =
          new DentistProcedureByDayOfWeekByShift(
              "", dentistProcedureByDayOfWeekId, shiftId);
    }

    checked = dentistProcedureByDayOfWeekByShiftId != "";

    _changeDetectorRef.markForCheck();
  }

  void onCheckedChange() {
    if (checked) {
      if (dentistProcedureByDayOfWeekByShiftService
                  .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
              dentistProcedureByDayOfWeekId + shiftId] ==
          null) {
        dentistProcedureByDayOfWeekByShiftService
                .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
            dentistProcedureByDayOfWeekId +
                shiftId] = new DentistProcedureByDayOfWeekByShift(
            "", dentistProcedureByDayOfWeekId, shiftId);
      }

      dentistProcedureByDayOfWeekByShiftService
          .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
              dentistProcedureByDayOfWeekId + shiftId]
          .dentistProcedureByDayOfWeekId = dentistProcedureByDayOfWeekId;

      dentistProcedureByDayOfWeekByShiftService
          .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
              dentistProcedureByDayOfWeekId + shiftId]
          .shiftId = shiftId;
    } else {
      if (dentistProcedureByDayOfWeekByShiftService
                  .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
              dentistProcedureByDayOfWeekId + shiftId] !=
          null) {
        dentistProcedureByDayOfWeekByShiftService
            .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
                dentistProcedureByDayOfWeekId + shiftId]
            .dentistProcedureByDayOfWeekId = "";

        dentistProcedureByDayOfWeekByShiftService
            .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
                dentistProcedureByDayOfWeekId + shiftId]
            .shiftId = "";
      }
    }

    _changeDetectorRef.markForCheck();
  }
}
