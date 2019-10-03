import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../model/field.dart';

@Component(
    selector: 'checkbox-component',
    styleUrls: const [
      'checkbox_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'checkbox_component.html',
    directives: const [coreDirectives, formDirectives, materialInputDirectives],
    providers: [windowBindings])
   
class CheckboxComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  Field field;

  @Input()
  ComponentRef componentRef;

  CheckboxComponent(this._changeDetectorRef);

  void ngOnInit() async {
    _changeDetectorRef.markForCheck();
  }
}
