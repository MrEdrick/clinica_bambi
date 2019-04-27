import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../agendamento/user/user_service.dart';

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
    providers: [
      windowBindings,
      datepickerBindings
    ])
class QuantityPerShiftComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 

  @Input()
  String dentistProcedureByDayOfWeek;

  @Input()
  String shift;

  @Input()
  String dayOfWeek;

  String quantity = '';

  QuantityPerShiftComponent(this._changeDetectorRef);

  void ngOnInit() {
    if (new UserService().user  == null)
      return;

    _changeDetectorRef.markForCheck();
  }

  @Output()
  Future<bool> onSave() async {
    Map datas = {"dentistId": dentistId, "procedureId": procedureId};
    bool saved = false;
    Map<bool, String> result;

    if (dentistProcedureId != "") {
      if (!checked) {
        for (ComponentRef shiftByDayGroupComponent
            in shiftByDayGroupListComponent) {
          saved = await shiftByDayGroupComponent.instance.onSave();
          if (!saved) {
            break;
          }
        }
        ;

        if (saved) {
          result[await new DentistProcedureDAO()
                  .delete(dentistProcedureService.dentistProcedure?.id) ==
              ""] = dentistProcedureService.dentistProcedure?.id;
        }
      } else {
        result[await new DentistProcedureDAO()
                .update(dentistProcedureService.dentistProcedure?.id, datas) ==
            ""] = dentistProcedureService.dentistProcedure?.id;

        for (ComponentRef shiftByDayGroupComponent
            in shiftByDayGroupListComponent) {
          shiftByDayGroupComponent.instance.dentistProcedureId =
              result.values.first;

          saved = await shiftByDayGroupComponent.instance.onSave();

          if (!saved) {
            break;
          }
        }
      }
    } else {
      result = await new DentistProcedureDAO().save(datas);

      for (ComponentRef shiftByDayGroupComponent
          in shiftByDayGroupListComponent) {
        shiftByDayGroupComponent.instance.dentistProcedureId =
            result.values.first;

        saved = await shiftByDayGroupComponent.instance.onSave();

        if (!saved) {
          break;
        }
      }
    }

    return saved;
  }
}
