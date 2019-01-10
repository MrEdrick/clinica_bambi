import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';

@Component(
  selector: 'telefone-fale-conosco-app',
  templateUrl: 'telefone_fale_conosco_component.html',
  directives: const [
    coreDirectives,
    AutoFocusDirective,
    MaterialIconComponent,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialInputComponent,
    materialInputDirectives,
  ],
  providers: const [materialProviders],
  styleUrls: const [
    'telefone_fale_conosco_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class TelefoneFaleConoscoComponent {
  bool multiline = true;

  String telephone = '';
  String mensage = '';

  void clickClose() {
    querySelector('telefone-fale-conosco-app').style.display = 'none';
    querySelector('#wh-widget-send-button').style.display = 'block';
  }


  void clickSend() {
  }
}
