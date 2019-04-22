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
}
