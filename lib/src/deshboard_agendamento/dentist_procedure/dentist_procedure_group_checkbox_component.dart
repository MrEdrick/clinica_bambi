import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import '../../agendamento/user/user_service.dart';

import '../../agendamento/dentist_procedure/dentist_procedure_service.dart';
import '../../agendamento/dentist_procedure/dentist_procedure.dart';
import '../../agendamento/dentist_procedure/dentist_procedure_dao.dart';

import 'package:ClinicaBambi/src/deshboard_agendamento/shift_by_day_group/shift_by_day_group_component.template.dart'
    as shift_by_day_group_component;

@Component(
    selector: 'dentist_procedure_group_checkbox_component',
    styleUrls: const [
      'dentist_procedure_group_checkbox_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'dentist_procedure_group_checkbox_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialCheckboxComponent,
    ],
    providers: [windowBindings, datepickerBindings])
class DentistProcedureGroupCheckboxComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  final DentistProcedureService dentistProcedureService =
      new DentistProcedureService();
  List<ComponentRef> shiftByDayGroupListComponent = new List<ComponentRef>();

  bool checked = false;
  String display = "none";

  String dentistProcedureId;

  @Input()
  String procedure = "";

  @Input()
  String procedureId = "";

  @Input()
  String dentistId = "";

  @ViewChild('dayShiftGroup', read: ViewContainerRef)
  ViewContainerRef materialContainerDayGroup;

  DentistProcedureGroupCheckboxComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    if ((dentistId != "") && (dentistId != null)) {
      (await dentistProcedureService.getOneDentistProcedureByFilterFromList(
          {"dentistId": dentistId, "procedureId": procedureId}));

      if (dentistProcedureService.dentistProcedureListByDentistIdProcedureId[
              dentistId + procedureId] ==
          null) {
        dentistProcedureId = "";
      } else {

        dentistProcedureId = dentistProcedureService
            .dentistProcedureListByDentistIdProcedureId[dentistId + procedureId]
            .id;
      }
    } else {
      dentistProcedureId = "";
      dentistProcedureService.dentistProcedure =
          new DentistProcedure("", dentistId, procedureId);
    }

    checked = dentistProcedureId != "";

    onCheckedChange();

    List _list = [
      'Domingo',
      'Segunda-Feira',
      'Terça-Feira',
      'Quarta-Feira',
      'Quinta-Feira',
      'Sexta-Feira',
      'Sábado'
    ];

    shiftByDayGroupListComponent.clear();

    _list.forEach((day) {
      ComponentFactory<shift_by_day_group_component.ShiftByDayGroupComponent>
          shiftByDayGroup =
          shift_by_day_group_component.ShiftByDayGroupComponentNgFactory;

      ComponentRef shiftByDayGroupComponent = _loader.loadNextToLocation(
          shiftByDayGroup, materialContainerDayGroup);

      if (dentistProcedureId == "") {
        shiftByDayGroupComponent.instance.dentistProcedureId = procedureId;
      } else {
        shiftByDayGroupComponent.instance.dentistProcedureId = dentistProcedureId;
      }
      
      shiftByDayGroupComponent.instance.dayOfWeek = day;
      shiftByDayGroupComponent.instance.shiftType = 'checkbox';

      shiftByDayGroupListComponent.add(shiftByDayGroupComponent);
    });

    _changeDetectorRef.markForCheck();
  }

  void onCheckedChange() {
    if (checked) {
      display = "block";

      if (dentistProcedureService.dentistProcedureListByDentistIdProcedureId[
              dentistId + procedureId] ==
          null) {
        dentistProcedureService.dentistProcedureListByDentistIdProcedureId[
                dentistId + procedureId] =
            new DentistProcedure("", dentistId, procedureId);
      }

      dentistProcedureService
          .dentistProcedureListByDentistIdProcedureId[dentistId + procedureId]
          .dentistId = dentistId;
      dentistProcedureService
          .dentistProcedureListByDentistIdProcedureId[dentistId + procedureId]
          .procedureId = procedureId;
    } else {
      display = "none";

      if (dentistProcedureService.dentistProcedureListByDentistIdProcedureId[
              dentistId + procedureId] !=
          null) {
        dentistProcedureService
            .dentistProcedureListByDentistIdProcedureId[dentistId + procedureId]
            .dentistId = "";

        dentistProcedureService
            .dentistProcedureListByDentistIdProcedureId[dentistId + procedureId]
            .procedureId = "";
      }
    }

    _changeDetectorRef.markForCheck();
  }
}
