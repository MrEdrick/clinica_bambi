import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../../model/field.dart';

@Component(
    selector: 'input-text-component',
    styleUrls: const [
      'input_text_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'input_text_component.html',
    directives: const [coreDirectives, formDirectives, materialInputDirectives],
    providers: [windowBindings])
   
class InputTextComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  Field field;

  @Input()
  ComponentRef componentRef;

  InputTextComponent(this._changeDetectorRef);

  void ngOnInit() async {
    _changeDetectorRef.markForCheck();
  }
}
