import 'dart:html';
import 'package:ClinicaBambi/src/appointment/dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../appointment/user/user_service.dart';
import '../../appointment/dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week_service.dart';

@Component(
    selector: 'quantity_per_shift_input_component',
    styleUrls: const [
      'quantity_per_shift_input_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'quantity_per_shift_input_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
    ],
    providers: [windowBindings, datepickerBindings])
class QuantityPerShiftComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final DentistQuantityPerShiftByDayOfWeekService
      dentistQuantityPerShiftByDayOfWeekService =
      new DentistQuantityPerShiftByDayOfWeekService();

  @Input()
  String shift;

  @Input()
  String shiftId;

  @Input()
  String dentistId;

  @Input()
  String dayOfWeek;

  String quantity = '';

  QuantityPerShiftComponent(this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    if ((shiftId != "") && (dentistId != "") && (dayOfWeek != "")) {
      quantity = dentistQuantityPerShiftByDayOfWeekService
          .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId[
              dentistId + dayOfWeek + shiftId]
          ?.quantity
          .toString();

      if (quantity == "null") {
        quantity = "";
      }
    } else {
      dentistQuantityPerShiftByDayOfWeekService
              .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId[
          dentistId +
              dayOfWeek +
              shiftId] = new DentistQuantityPerShiftByDayOfWeek(
          "", dentistId, dayOfWeek, shiftId, 0);
      quantity = "";
    }

    _changeDetectorRef.markForCheck();
  }

  onKeydownJustInteger(event) {
    if ((event.keyCode == KeyCode.BACKSPACE) ||
        (event.keyCode == KeyCode.RIGHT) ||
        (event.keyCode == KeyCode.LEFT) ||
        (event.keyCode == KeyCode.TAB)) {
      return;
    }

    if (int.tryParse(event.key) == null) {
      event.preventDefault();
    }
  }

  onKeyUp(event) {
    dentistQuantityPerShiftByDayOfWeekService
        .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId[
            dentistId + dayOfWeek + shiftId]
        .quantity = quantity == "" ? 0 : int.tryParse(quantity);
  }
}
