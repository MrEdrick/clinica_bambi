import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/utils/browser/window/module.dart';

@Component(
    selector: 'dentista-turno-quantidade-app',
    styleUrls: const [
      'dentista_turno_quantidade_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'dentista_turno_quantidade_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
    ],
    providers: [
      windowBindings,
      datepickerBindings
    ])
class DentistaTurnoQuantidadeComponent implements OnInit {
  String turno;
  String quantidadePorTurno;

  Map<String, dynamic> datas;

  void ngOnInit() {
  }

}
