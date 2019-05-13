import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import '../../agendamento/user/user_service.dart';

import '../../agendamento/dentist_procedure_by_day_of_week_by_shift/dentist_procedure_by_day_of_week_by_shift.dart';
import '../../agendamento/dentist_procedure_by_day_of_week_by_shift/dentist_procedure_by_day_of_week_by_shift_service.dart';

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
    print("t0");
    if ((dentistProcedureByDayOfWeekId != "") ||
        (dentistProcedureByDayOfWeekId != null)) {
      (await dentistProcedureByDayOfWeekByShiftService
          .getOneDentistProcedureByDayOfWeekByShiftByFilterFromList({
        "dentistProcedureByDayOfWeekId": dentistProcedureByDayOfWeekId,
        "shiftId": shiftId
      }));
      print("t1");
      if (dentistProcedureByDayOfWeekByShiftService
                  .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
              dentistProcedureByDayOfWeekId + shiftId] ==
          null) {
            print("t2");
        dentistProcedureByDayOfWeekByShiftId = "";
      } else {
        print("t3");
        dentistProcedureByDayOfWeekByShiftId = dentistProcedureByDayOfWeekByShiftService
            .dentistProcedureByDayOfWeekByShiftListByDentistProcedureByDayOfWeekIdShiftId[
                dentistProcedureByDayOfWeekId + shiftId]
            .id;
      }
    } else {
      print("t4");
      dentistProcedureByDayOfWeekByShiftId = "";
      dentistProcedureByDayOfWeekByShiftService
              .dentistProcedureByDayOfWeekByShift =
          new DentistProcedureByDayOfWeekByShift(
              "", dentistProcedureByDayOfWeekId, shiftId);
    }
    print("t5");
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
                dentistProcedureByDayOfWeekId + dayOfWeek]
            .shiftId = "";
      }
    }

    _changeDetectorRef.markForCheck();
  }
}
