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

import '../../agendamento/dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week_service.dart';
import '../../agendamento/dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week.dart';

import '../../agendamento/dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week_service.dart';
import '../../agendamento/dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week.dart';

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
  final DentistQuantityPerShiftByDayOfWeekService
      dentistQuantityPerShiftByDayOfWeekService =
      new DentistQuantityPerShiftByDayOfWeekService();

  List<ComponentRef> shiftByDayGroupListComponent = new List<ComponentRef>();

  String dentistProcedureByDayOfWeekId;

  @Input()
  String dentistProcedureId = "";

  @Input()
  String procedureId = "";

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

    List<Shift> _list = await new ShiftService().getAllShiftAcives();
    
    if (shiftType == 'checkbox') {
      if ((dentistProcedureId != "") && (dentistProcedureId != null)) {
        (await dentistProcedureByDayOfWeekService
            .getOneDentistProcedureByDayOfWeekByFilterFromList({
          "dentistProcedureId": dentistProcedureId,
          "dayOfWeek": dayOfWeek
        }));

        if (dentistProcedureByDayOfWeekService
                    .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
                dentistProcedureId + dayOfWeek] ==
            null) {
          dentistProcedureByDayOfWeekId = "";
        } else {
          dentistProcedureByDayOfWeekId = dentistProcedureByDayOfWeekService
              .dentistProcedureByDayOfWeekListByDentistProcedureIdDayOfWeek[
                  dentistProcedureId + dayOfWeek]
              .id;
        }
      } else {
        dentistProcedureByDayOfWeekId = "";
        dentistProcedureByDayOfWeekService.dentistProcedureByDayOfWeek =
            new DentistProcedureByDayOfWeek("", dentistProcedureId, dayOfWeek);
      }

      checked = dentistProcedureByDayOfWeekId != "";
    } else {
      await (_list.forEach((shift) async {
        (await dentistQuantityPerShiftByDayOfWeekService
            .getOneDentistQuantityPerShiftByDayOfWeekByFilterFromList({
          "dentistId": dentistId,
          "dayOfWeek": dayOfWeek,
          "shiftId": shift.id        
        }));

        if (dentistQuantityPerShiftByDayOfWeekService
                    .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId[
                dentistId + dayOfWeek + shift.id] !=
            null) {
          checked = true;
        }
      }));
    }

    onCheckedChange();

    shiftByDayGroupListComponent.clear();

    _list.forEach((shift) {
      if (shiftType == 'checkbox') {
        ComponentFactory<shift_checkbox_component.ShiftCheckboxComponent>
            shiftComponent =
            shift_checkbox_component.ShiftCheckboxComponentNgFactory;

        ComponentRef shiftCheckboxComponent = _loader.loadNextToLocation(
            shiftComponent, materialContainerShitGroup);

        if (dentistProcedureByDayOfWeekId == "") {
          shiftCheckboxComponent.instance.dentistProcedureByDayOfWeekId =
              procedureId + dentistProcedureId + dayOfWeek;
        } else {
          shiftCheckboxComponent.instance.dentistProcedureByDayOfWeekId =
              dentistProcedureByDayOfWeekId;
        }

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

  void onCheckedChange() async {
    if (checked) {
      display = "block";
      if (shiftType == 'checkbox') {
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
        List<Shift> _list = await new ShiftService().getAllShiftAcives();

        _list.forEach((shift) {
          if (dentistQuantityPerShiftByDayOfWeekService
                      .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId[
                  dentistId + dayOfWeek + shift.id] ==
              null) {
            dentistQuantityPerShiftByDayOfWeekService
                    .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId[
                dentistId +
                    dayOfWeek +
                    shift.id] = new DentistQuantityPerShiftByDayOfWeek(
                "", dayOfWeek, dentistId, shift.id, 0);
          }

          dentistQuantityPerShiftByDayOfWeekService
              .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId[
                  dentistId + dayOfWeek + shift.id]
              .shiftId = shift.id;
        });
      }
    } else {
      display = "none";
      if (shiftType == 'checkbox') {
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
      } else {
        List<Shift> _list = await new ShiftService().getAllShiftAcives();

        _list.forEach((shift) {
          if (dentistQuantityPerShiftByDayOfWeekService
                      .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId[
                  dentistId + dayOfWeek + shift.id] !=
              null) {
            dentistQuantityPerShiftByDayOfWeekService
                .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId[
                    dentistId + dayOfWeek + shift.id]
                .shiftId = "";
          }
        });
      }
    }

    _changeDetectorRef.markForCheck();
  }
}
