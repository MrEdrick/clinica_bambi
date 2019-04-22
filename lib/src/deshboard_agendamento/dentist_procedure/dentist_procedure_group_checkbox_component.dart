import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import '../../agendamento/user/user_service.dart';

import 'package:ClinicaBambi/src/deshboard_agendamento/shift_by_day_group/shift_by_day_group_checkbox_component.template.dart'
    as shift_by_day_group_checkbox_component;

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

  @Input()
  String procedure;

  @ViewChild('dayShiftGroup',
      read: ViewContainerRef)
  ViewContainerRef materialContainerDayGroup;

  DentistProcedureGroupCheckboxComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() async {
    if (new UserService().user == null) return;
    List _list = ['Domingo', 'Segunda-Feira', 'Terça-Feira', 
                  'Quarta-Feira', 'Quinta-Feira', 'Sexta-Feira', 
                  'Sábado'];

    _list.forEach((day) {
      ComponentFactory<
              shift_by_day_group_checkbox_component
                  .ShiftByDayGroupCheckboxComponent>
          shiftByDayGroup = shift_by_day_group_checkbox_component
              .ShiftByDayGroupCheckboxComponentNgFactory;

      ComponentRef shiftByDayGroupComponent =
          _loader.loadNextToLocation(
              shiftByDayGroup, materialContainerDayGroup);

      shiftByDayGroupComponent.instance.dayOfWeek = day;
      shiftByDayGroupComponent.instance.shiftType = 'checkbox';
    });

    _changeDetectorRef.markForCheck();
  }
}
