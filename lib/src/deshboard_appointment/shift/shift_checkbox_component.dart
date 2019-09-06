import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import '../../appointment/user/user_service.dart';

import '../../appointment/dentist_procedure_by_day_of_week_by_shift/dentist_procedure_by_day_of_week_by_shift.dart';
import '../../appointment/dentist_procedure_by_day_of_week_by_shift/dentist_procedure_by_day_of_week_by_shift_service.dart';

@Component(
    selector: 'shift_checkbox_component',
    styleUrls: const [
      'shift_checkbox_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'shift_checkbox_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialCheckboxComponent,
    ])
class ShiftCheckboxComponent implements OnInit {
  final DentistProcedureByDayOfWeekByShiftService
      dentistProcedureByDayOfWeekByShiftService =
      new DentistProcedureByDayOfWeekByShiftService();
  final ChangeDetectorRef _changeDetectorRef;

  String dentistProcedureByDayOfWeekByShiftId;

  @Input()
  String dentistProcedureByDayOfWeekId;

  @Input()
  String shiftId;

  @Input()
  String shift;

  @Input()
  String dayOfWeek;

  bool checked = false;

  ShiftCheckboxComponent(this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;
    
    if ((dentistProcedureByDayOfWeekId != "") &&
        (dentistProcedureByDayOfWeekId != null)) {
      (await dentistProcedureByDayOfWeekByShiftService
          .getOneDentistProcedureByDayOfWeekByShiftByFilterFromList({
        "dentistProcedureByDayOfWeekId": dentistProcedureByDayOfWeekId,
        "shiftId": shiftId
      }));
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
