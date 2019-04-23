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
  
  ComponentRef shiftCheckboxComponent;
  ComponentRef quantityPerShiftInputComponent;

  @Input()
  String dentistProcedureByDayOfWeekId;

  @Input()
  String dentistProcedureId;

  @Input()
  String dayOfWeek;

  @Input()
  String shiftType;

  @ViewChild('shiftGroup', read: ViewContainerRef)
  ViewContainerRef materialContainerShitGroup;

  ShiftByDayGroupComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    List<Shift> _list = await new ShiftService().getAllShiftAcives();

    _list.forEach((shift) {
      if (shiftType == 'checkbox') {
        ComponentFactory<shift_checkbox_component.ShiftCheckboxComponent>
            shiftComponent =
            shift_checkbox_component.ShiftCheckboxComponentNgFactory;

        shiftCheckboxComponent =
            _loader.loadNextToLocation(
                shiftComponent, materialContainerShitGroup);

        shiftCheckboxComponent.instance.shift = shift.description;
      } else {
        ComponentFactory<quantity_per_shift_component.QuantityPerShiftComponent>
            shiftComponent =
            quantity_per_shift_component.QuantityPerShiftComponentNgFactory;

        quantityPerShiftInputComponent =
            _loader.loadNextToLocation(
                shiftComponent, materialContainerShitGroup);

        quantityPerShiftInputComponent.instance.shift = shift.description;
      }
    });

    _changeDetectorRef.markForCheck();
  }

  @Output()
  Future<bool> onSave() async {
    Map datas = {"dentistProcedureId": dentistProcedureId, "dayOfWeek": dayOfWeek};

    Map<bool, String> result;

    if (dentistProcedureByDayOfWeekId != "") {
      result[await new DentistProcedureByDayOfWeekDAO().update(dentistProcedureByDayOfWeekId, datas) ==
          ""] = dentistProcedureByDayOfWeekId;
    } else {
      result = await new DentistProcedureByDayOfWeekDAO().save(datas);
    }

    if (result.keys.first) {
      if (shiftType == 'checkbox') {
        shiftCheckboxComponent.instance.dentistProcedureByDayOfWeekId =
          result.values.first;
      } else {
        quantityPerShiftInputComponent.instance.dentistProcedureByDayOfWeekId =
          result.values.first;
      }

      if ((shiftType == 'checkbox') ? await shiftCheckboxComponent.instance.onSave() : quantityPerShiftInputComponent.instance.onSave()) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

}
