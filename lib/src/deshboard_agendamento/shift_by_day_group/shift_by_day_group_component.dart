import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import '../../agendamento/shift/shift.dart';
import '../../agendamento/shift/shift_service.dart';
import '../../agendamento/user/user_service.dart';

import '../../agendamento/dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week_dao.dart';
import '../../agendamento/dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week_service.dart';

import 'package:ClinicaBambi/src/deshboard_agendamento/shift/quantity_per_shift_input_component.template.dart'
    as quantity_per_shift_component;

import 'package:ClinicaBambi/src/deshboard_agendamento/shift/shift_checkbox_component.template.dart'
    as shift_checkbox_component;

@Component(
    selector: 'shift_by_day_group_component',
    styleUrls: const [
      'shift_by_day_group_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'shift_by_day_group_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialCheckboxComponent,
    ],
    providers: [windowBindings, datepickerBindings])
class ShiftByDayGroupComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  final DentistProcedureByDayOfWeekService dentistProcedureByDayOfWeekService =
      new DentistProcedureByDayOfWeekService();

  List<ComponentRef> shiftByDayGroupListComponent = new List<ComponentRef>();

  String dentistProcedureByDayOfWeekId;

  @Input()
  String dentistProcedureId = "";

  @Input()
  String dentistId = "";

  @Input()
  String dayOfWeek = "";

  @Input()
  String shiftType = "";

  bool checked = false;
  String display = "none";

  @ViewChild('shiftGroup', read: ViewContainerRef)
  ViewContainerRef materialContainerShitGroup;

  ShiftByDayGroupComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    if ((dentistProcedureId != "") && (dayOfWeek != "")) {
      dentistProcedureByDayOfWeekId = (await dentistProcedureByDayOfWeekService
              .getOneDentistProcedureByDayOfWeekByFilter({
        "dentistProcedureId": dentistProcedureId,
        "dayOfWeek": dayOfWeek
      }))
          ?.id;
    } else {
      dentistProcedureByDayOfWeekId = "";
    }

    checked = dentistProcedureByDayOfWeekId != "";

    onCheckedChange();

    List<Shift> _list = await new ShiftService().getAllShiftAcives();

    shiftByDayGroupListComponent.clear();

    _list.forEach((shift) {
      if (shiftType == 'checkbox') {
        ComponentFactory<shift_checkbox_component.ShiftCheckboxComponent>
            shiftComponent =
            shift_checkbox_component.ShiftCheckboxComponentNgFactory;

        ComponentRef shiftCheckboxComponent = _loader.loadNextToLocation(
            shiftComponent, materialContainerShitGroup);

        shiftCheckboxComponent.instance.dentistProcedureByDayOfWeekId =
            dentistProcedureByDayOfWeekId;
        shiftCheckboxComponent.instance.shiftId = shift.id;
        shiftCheckboxComponent.instance.shift = shift.description;

        shiftByDayGroupListComponent.add(shiftCheckboxComponent);
      } else {
        ComponentFactory<quantity_per_shift_component.QuantityPerShiftComponent>
            shiftComponent =
            quantity_per_shift_component.QuantityPerShiftComponentNgFactory;

        ComponentRef quantityPerShiftInputComponent = _loader
            .loadNextToLocation(shiftComponent, materialContainerShitGroup);

        quantityPerShiftInputComponent.instance.shiftId = shift.id;
        quantityPerShiftInputComponent.instance.shift = shift.description;
        quantityPerShiftInputComponent.instance.dayOfWeek = dayOfWeek;
        quantityPerShiftInputComponent.instance.dentistId = dentistId;

        shiftByDayGroupListComponent.add(quantityPerShiftInputComponent);
      }
    });

    _changeDetectorRef.markForCheck();
  }

  @Output()
  Future<bool> onSave() async {
    Map datas = {
      "dentistProcedureId": dentistProcedureId,
      "dayOfWeek": dayOfWeek
    };

    bool saved = false;

    Map<bool, String> result = new Map<bool, String>();

    if (dentistProcedureByDayOfWeekId != "") {
      if (!checked) {
        for (ComponentRef shiftByDayGroupComponent
            in shiftByDayGroupListComponent) {
          saved = await shiftByDayGroupComponent.instance.onSave();

          if (!saved) {
            break;
          }
        }

        if (saved) {
          result[await new DentistProcedureByDayOfWeekDAO()
                  .delete(dentistProcedureByDayOfWeekId) ==
              ""] = dentistProcedureByDayOfWeekId;
        }
      } else {
        result[await new DentistProcedureByDayOfWeekDAO()
                .update(dentistProcedureByDayOfWeekId, datas) ==
            ""] = dentistProcedureByDayOfWeekId;

        if (result.keys.first) {
          for (ComponentRef shiftByDayGroupComponent
              in shiftByDayGroupListComponent) {
            shiftByDayGroupComponent.instance.dentistProcedureByDayOfWeekId =
                result.values.first;

            saved = await shiftByDayGroupComponent.instance.onSave();

            if (!saved) {
              break;
            }
          }
        }
      }
    } else {
      result = await new DentistProcedureByDayOfWeekDAO().save(datas);

      if (result.keys.first) {
        for (ComponentRef shiftByDayGroupComponent
            in shiftByDayGroupListComponent) {
          shiftByDayGroupComponent.instance.dentistProcedureByDayOfWeekId =
              result.values.first;

          saved = await shiftByDayGroupComponent.instance.onSave();

          if (!saved) {
            break;
          }
        }
      }
    }

    return saved;
  }

  void onCheckedChange() {
    if (checked) {
      display = "block";
    } else {
      display = "none";
    }

    _changeDetectorRef.markForCheck();
  }
}
