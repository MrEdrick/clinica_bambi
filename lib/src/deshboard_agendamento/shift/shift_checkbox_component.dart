import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';

import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'shift_checkbox_component',
    styleUrls: const [
      'shift_checkbox_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'shift_checkbox_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
    ])
class ShiftCheckboxComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 

  @Input()
  String shift;

  @Input()
  String dayOfWeek;

  ShiftCheckboxComponent(this._changeDetectorRef);

  void ngOnInit() {
    if (new UserService().user  == null)
      return;

    _changeDetectorRef.markForCheck();
  }
}
