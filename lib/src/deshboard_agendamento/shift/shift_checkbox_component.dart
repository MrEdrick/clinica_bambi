import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import '../../agendamento/user/user_service.dart';

import '../../agendamento/dentist_procedure_by_day_of_week_by_shift/dentist_procedure_by_day_of_week_by_shift_dao.dart';
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

    dentistProcedureByDayOfWeekByShiftId =
        (await dentistProcedureByDayOfWeekByShiftService
                .getOneDentistProcedureByDayOfWeekByShiftByFilter({
      "dentistProcedureByDayOfWeekId": dentistProcedureByDayOfWeekId,
      "shiftId": shiftId
    }))
            ?.id;

    checked = dentistProcedureByDayOfWeekByShiftId != "";

    _changeDetectorRef.markForCheck();
  }

  @Output()
  Future<bool> onSave() async {
    Map datas = {
      "dentistProcedureByDayOfWeekId": dentistProcedureByDayOfWeekId,
      "shiftId": shiftId
    };

    Map<bool, String> result;

    if (dentistProcedureByDayOfWeekByShiftId != "") {
      if (!checked) {
        result[await new DentistProcedureByDayOfWeekByShiftDAO()
                .delete(dentistProcedureByDayOfWeekByShiftId) ==
            ""] = dentistProcedureByDayOfWeekByShiftId;
      } else {
        result[await new DentistProcedureByDayOfWeekByShiftDAO()
                .update(dentistProcedureByDayOfWeekByShiftId, datas) ==
            ""] = dentistProcedureByDayOfWeekByShiftId;
      }
    } else {
      result = await new DentistProcedureByDayOfWeekByShiftDAO().save(datas);
    }

    if (result.keys.first) {
      return true;
    } else {
      return false;
    }
  }
}
