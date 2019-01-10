import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

@Component(
  selector: 'map-app',
  templateUrl: 'map_component.html',
  directives: const [
    MaterialButtonComponent,
    MaterialIconComponent,
    ModalComponent
  ],
  providers: const [materialProviders],
  styleUrls: const [
    'map_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class MapComponent {

  void clickClose() {
    querySelector('map-app').style.display = 'none';
    querySelector('#wh-widget-send-button').style.display = 'block';
  }
}
