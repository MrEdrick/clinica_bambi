import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

@Component(
    selector: 'string-label-component',
    styleUrls: const [
      'string_label_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'string_label_component.html',
    changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives
    ])

class StringLabelComponent implements OnInit {
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


  StringLabelComponent(this._changeDetectorRef);

  @override
  void ngOnInit() {
    _changeDetectorRef.markForCheck();
  }
}
