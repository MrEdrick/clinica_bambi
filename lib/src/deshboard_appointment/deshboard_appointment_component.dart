import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/material_datepicker/date_range_input.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';

import '../appointment/core/view/deshboard/deshboard_component.dart';
import '../appointment/core/model/application.dart';
import '../appointment/core/model/archive.dart';
import '../appointment/core/model/collection.dart';
import '../appointment/core/model/field.dart';

@Component(
  selector: 'deshboard_appointment_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'deshboard_appointment_component.html',
  directives: const [
    coreDirectives,
    materialInputDirectives,
    NgFor,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialToggleComponent,
    MaterialDatepickerComponent,
    DateRangeInputComponent,
    MaterialDropdownSelectComponent,
    MultiDropdownSelectValueAccessor,
    MaterialFabComponent,
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'deshboard_appointment_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DeshboardAppointmentComponent extends DeshboardComponent {
  final Router _router;
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  DeshboardAppointmentComponent(
      this._router, this._loader, this._changeDetectorRef) //, this._location
      : super(_router, _loader, _changeDetectorRef) {
    super.application = new Application(
        "Clínica Bambi",
        null,
        [
          new Archive(
              "AppointmentSchedulingRegistration",
              null,
              [
                new Collection(
                    "AppointmentScheduling",
                    null,
                    [new Field(_description, _type, _value, _title)],
                    "Agendamentos",
                    "calendar_today"),
                new Collection(
                    "Dentist",
                    null,
                    [new Field(_description, _type, _value, _title)],
                    "Dentistas",
                    "person_outline"),
                new Collection(
                    "Procedure",
                    null,
                    [new Field(_description, _type, _value, _title)],
                    "Procedimentos",
                    "list_alt"),
                new Collection(
                    "Requirement",
                    null,
                    [new Field(_description, _type, _value, _title)],
                    "Requisitos",
                    "check_box")
              ],
              "Cadastro de Agendamentos",
              "icon")
        ],
        "Clínica Bambi",
        "icon");
  }
}
