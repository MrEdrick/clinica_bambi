import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'galeria-app',
  templateUrl: 'galeria_component.html',
  directives: const [
    coreDirectives],
  providers: const [materialProviders],
  styleUrls: const [
    'galeria_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class GaleriaComponent {

  void clickImg(String href) {
    querySelector('#wh-widget-send-button').style.display = 'none';
    querySelector('#galeria-img-large').style.display = 'inline-block';
    querySelector('#img-large').style.backgroundImage = 'url('+ href + ')';
  }

  void clickClose() {
    querySelector('#galeria-img-large').style.display = 'none';
    querySelector('#wh-widget-send-button').style.display = 'block';
  }

}
