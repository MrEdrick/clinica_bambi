import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../email_fale_conosco/email_fale_conosco_component.dart';
import '../telefone_fale_conosco/telefone_fale_conosco_component.dart';
import '../map/map_component.dart';

import 'package:google_maps/google_maps.dart';

@Component(
  selector: 'a-clinica-app',
  templateUrl: 'a_clinica_component.html',
  directives: const [
    coreDirectives,
    TelefoneFaleConoscoComponent,
    EmailFaleConoscoComponent,
    MapComponent
  ],
  providers: const [materialProviders],
  styleUrls: const [
    'a_clinica_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AClinicaCmponent {

  void clickMapa() {
    //querySelector('#wh-widget-send-button').style.display = 'none';
    querySelector('map-app').style.display = 'block';
    
    final mapOptions = new MapOptions()
      ..zoom = 17
      ..center = new LatLng(-22.8730096, -43.3390069);

    var map = new GMap(querySelector(".map"), mapOptions);

    final marker = new Marker(MarkerOptions()
      ..position = new LatLng(-22.8730096, -43.3390069)
      ..map = map);
    
  }

  void clickTelefoneFaleConosco() {
    //querySelector('#wh-widget-send-button').style.display = 'none';
    querySelector('telefone-fale-conosco-app').style.display = 'block';
  }

  void clickEmailFaleConosco() {
    //querySelector('#wh-widget-send-button').style.display = 'none';
    querySelector('email-fale-conosco-app').style.display = 'block';
  }
}
