import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'quantity_per_shift_by_day_group_checkbox_component',
    styleUrls: const [
      'quantity_per_shift_by_day_group_checkbox_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'quantity_per_shift_by_day_group_checkbox_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialCheckboxComponent,
    ],
    providers: [windowBindings, datepickerBindings])
class QuantityPerShiftByDayGroupCheckboxComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  String dayOfWeek;

  QuantityPerShiftByDayGroupCheckboxComponent(this._changeDetectorRef);

  void ngOnInit() {
    if (new UserService().user == null) return;

    _changeDetectorRef.markForCheck();
  }
}
