import 'package:angular/angular.dart';
import 'package:angular_components/material_icon/material_icon.dart';

@Component(
    selector: 'boolean-label-component',
    styleUrls: const [
      'boolean_label_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'boolean_label_component.html',
    changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      coreDirectives,
      MaterialIconComponent
    ])

class BooleanLabelComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 

  String _title;
  String _value;

  @Input()
  ComponentRef componentRef;

  String get title => _title;
  @Input()
  set title(String title) => _title = title; 

  String get value => _value;
  @Input()
  set value(String value) => _value = value; 


  BooleanLabelComponent(this._changeDetectorRef);

  @override
  void ngOnInit() {
    _changeDetectorRef.markForCheck();
  }
}
