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
import '../../agendamento/dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week.dart';

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
    print("t0");
    if ((dentistProcedureId != "") && (dentistProcedureId != null)) {
      (await dentistProcedureByDayOfWeekService
          .getOneDentistProcedureByDayOfWeekByFilterFromList({
        "dentistProcedureId": dentistProcedureId,
        "dayOfWeek": dayOfWeek
      }));
      print("t1");
      if (dentistProcedureByDayOfWeekService
                  .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
              dentistProcedureId + dayOfWeek] ==
          null) {
        dentistProcedureByDayOfWeekId = "";
      } else {
        dentistProcedureByDayOfWeekId = "";
        print(dentistProcedureByDayOfWeekService
                .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
            dentistProcedureId + dayOfWeek]);
      }
    } else {
      dentistProcedureByDayOfWeekId = "";
      dentistProcedureByDayOfWeekService.dentistProcedureByDayOfWeek =
          new DentistProcedureByDayOfWeek("", dentistProcedureId, dayOfWeek);
    }
    print("t2");
    checked = dentistProcedureByDayOfWeekId != "";

    onCheckedChange();
    print("t3");
    List<Shift> _list = await new ShiftService().getAllShiftAcives();

    shiftByDayGroupListComponent.clear();

    _list.forEach((shift) {
      if (shiftType == 'checkbox') {
        ComponentFactory<shift_checkbox_component.ShiftCheckboxComponent>
            shiftComponent =
            shift_checkbox_component.ShiftCheckboxComponentNgFactory;
        print("t4");
        ComponentRef shiftCheckboxComponent = _loader.loadNextToLocation(
            shiftComponent, materialContainerShitGroup);
        print("t5");
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

  void onCheckedChange() {
    if (checked) {
      display = "block";

      if (dentistProcedureByDayOfWeekService
                  .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
              dentistProcedureId + dayOfWeek] ==
          null) {
        dentistProcedureByDayOfWeekService
                .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
            dentistProcedureId +
                dayOfWeek] = new DentistProcedureByDayOfWeek(
            "", dentistProcedureId, dayOfWeek);
      }

      dentistProcedureByDayOfWeekService
          .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
              dentistProcedureId + dayOfWeek]
          .dentistProcedureId = dentistProcedureId;
      dentistProcedureByDayOfWeekService
          .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
              dentistProcedureId + dayOfWeek]
          .dayOfWeek = dayOfWeek;
    } else {
      display = "none";

      if (dentistProcedureByDayOfWeekService
                  .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
              dentistProcedureId + dayOfWeek] !=
          null) {
        dentistProcedureByDayOfWeekService
            .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
                dentistProcedureId + dayOfWeek]
            .dentistProcedureId = "";

        dentistProcedureByDayOfWeekService
            .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
                dentistProcedureId + dayOfWeek]
            .dayOfWeek = "";
      }
    }

    _changeDetectorRef.markForCheck();
  }
}
