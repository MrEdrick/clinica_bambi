import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

@Component(
    selector: 'label-app',
    styleUrls: const [
      'label_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'label_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives
    ])

class LabelComponent {
  String _title;
  String _value;
  
  String get title => _title;
  @Input()
  set title(String title) => _title = title; 

  String get value => _value;
  @Input()
  set value(String value) => _value = value; 


  LabelComponent();
}
