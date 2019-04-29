import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../agendamento/user/user_service.dart';
import '../../agendamento/dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week_dao.dart';
import '../../agendamento/dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week_service.dart';

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

  String dentistQuantityPerShiftByDayOfWeekId;

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
      dentistQuantityPerShiftByDayOfWeekId =
          (await dentistQuantityPerShiftByDayOfWeekService
                  .getOneDentistQuantityPerShiftByDayOfWeekByFilter({
        "dentistId": dentistId,
        "shiftId": shiftId,
        "dayOfWeek": dayOfWeek
      }))
              ?.id;

      quantity = (await dentistQuantityPerShiftByDayOfWeekService
              .getOneDentistQuantityPerShiftByDayOfWeekByFilter({
        "dentistId": dentistId,
        "shiftId": shiftId,
        "dayOfWeek": dayOfWeek
      }))
          ?.quantity
          .toString();
      
      if (quantity == "null") {
        quantity = "";
      }
      
    } else {
      dentistQuantityPerShiftByDayOfWeekId = "";
      quantity = "";
    }

    _changeDetectorRef.markForCheck();
  }

  @Output()
  Future<bool> onSave() async {
    Map datas = {
      "dentistId": dentistId,
      "shiftId": shiftId,
      "dayOfWeek": dayOfWeek,
      "quantity": int.parse(quantity)
    };

    Map<bool, String> result = new Map<bool, String>();

    if (dentistQuantityPerShiftByDayOfWeekId != "") {
      result[await new DentistQuantityPerShiftByDayOfWeekDAO().update(
                  dentistQuantityPerShiftByDayOfWeekService
                      .dentistQuantityPerShiftByDayOfWeek?.id,
                  datas) ==
              ""] =
          dentistQuantityPerShiftByDayOfWeekService
              .dentistQuantityPerShiftByDayOfWeek?.id;
    } else {
      result = await new DentistQuantityPerShiftByDayOfWeekDAO().save(datas);
    }

    return result.keys.first;
  }
}
