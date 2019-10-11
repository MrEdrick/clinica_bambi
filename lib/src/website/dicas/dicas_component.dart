import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import '../textos_dicas/textos_dicas_component.dart';
import '../textos_saude/textos_saude_component.dart';
import '../textos_artigos/textos_artigos_component.dart';
import '../textos_cuidados/textos_cuidados_component.dart';

@Component(
  selector: 'dicas-app',
  templateUrl: 'dicas_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [
    coreDirectives,
    TextosDicasComponent,
    TextosSaudeComponent,
    TextosArtigosComponent,
    TextosCuidadosComponent
  ],
  providers: const [materialProviders],
  styleUrls: const [
    'dicas_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DicasComponent {
  void clickDicas() {

    if (window.innerWidth >= 1100) {
      querySelector('#dicas-content').style.left = '0%';
      querySelector('#dicas-content').style.top = '0%';
      querySelector('#dicas-content').style.borderRadius = '0px';
      querySelector('#dicas-content').style.width = '100%';
      querySelector('#dicas-content').style.height = '100%';
      querySelector('#dicas-content').style.position = 'fixed';
      querySelector('textos-dicas-app').style.display = 'flex';
    } else {
      querySelector('textos-dicas-app').style.display = 'inline-block';
    }

    querySelector('#dicas-content').style.zIndex = '2';
    querySelector('#button-close').style.zIndex = '3';

    querySelector('#title-decorator-dicas').style.display = 'none';
    querySelector('#wh-widget-send-button').style.display = 'none';

    querySelector('#button-close').style.display = 'inline-block';
  }

  void clickArtigos() {
    if (window.innerWidth >= 1100) {
      querySelector('#artigos-content').style.left = '0%';
      querySelector('#artigos-content').style.top = '0%';
      querySelector('#artigos-content').style.borderRadius = '0px';
      querySelector('#artigos-content').style.width = '100%';
      querySelector('#artigos-content').style.height = '100%';
      querySelector('#artigos-content').style.position = 'fixed';
      querySelector('textos-artigos-app').style.display = 'flex';
    } else {
      querySelector('textos-artigos-app').style.display = 'block';
    }

    querySelector('#artigos-content').style.zIndex = '2';
    querySelector('#button-close').style.zIndex = '3';

    querySelector('#title-decorator-artigos').style.display = 'none';
    querySelector('#wh-widget-send-button').style.display = 'none';

    querySelector('#button-close').style.display = 'inline-block';
  }

  void clickCuidados() {
    if (window.innerWidth >= 1100) {
      querySelector('#cuidados-content').style.left = '0%';
      querySelector('#cuidados-content').style.top = '0%';
      querySelector('#cuidados-content').style.borderRadius = '0px';
      querySelector('#cuidados-content').style.width = '100%';
      querySelector('#cuidados-content').style.height = '100%';
      querySelector('#cuidados-content').style.position = 'fixed';
      querySelector('textos-cuidados-app').style.display = 'flex';
    } else {
      querySelector('textos-cuidados-app').style.display = 'block';
    }

    querySelector('#cuidados-content').style.zIndex = '2';
    querySelector('#button-close').style.zIndex = '3';

    querySelector('#title-decorator-cuidados').style.display = 'none';
    querySelector('#wh-widget-send-button').style.display = 'none';

    querySelector('#button-close').style.display = 'inline-block';
  }

  void clickSaude() {
    if (window.innerWidth >= 1100) {
      querySelector('#saude-content').style.left = '0%';
      querySelector('#saude-content').style.top = '0%';
      querySelector('#saude-content').style.borderRadius = '0px';
      querySelector('#saude-content').style.width = '100%';
      querySelector('#saude-content').style.height = '100%';
      querySelector('#saude-content').style.position = 'fixed';
      querySelector('textos-saude-app').style.display = 'flex';
    } else {
      querySelector('textos-saude-app').style.display = 'block';
    }

    querySelector('#saude-content').style.zIndex = '2';
    querySelector('.button-close').style.zIndex = '3';

    querySelector('#title-decorator-saude').style.display = 'none';
    querySelector('#wh-widget-send-button').style.display = 'none';

    querySelector('#button-close').style.display = 'inline-block';
  }

  void clickClose() {
    Element content;

    querySelector('#dicas-content').style.zIndex = '';
    querySelector('#saude-content').style.zIndex = '';
    querySelector('#cuidados-content').style.zIndex = '';
    querySelector('#artigos-content').style.zIndex = '';

    querySelector('#dicas-content').style.position = '';
    querySelector('#saude-content').style.position = '';
    querySelector('#cuidados-content').style.position = '';
    querySelector('#artigos-content').style.position = '';

    querySelector('#textos-container-dicas').style.display = 'none';
    querySelector('#textos-container-saude').style.display = 'none';
    querySelector('#textos-container-cuidados').style.display = 'none';
    querySelector('#textos-container-artigos').style.display = 'none';

    querySelector('#button-close').style.display = 'none';

    querySelector('#title-decorator-dicas').style.display = 'block';
    querySelector('#title-decorator-saude').style.display = 'block';
    querySelector('#title-decorator-cuidados').style.display = 'block';
    querySelector('#title-decorator-artigos').style.display = 'block';
    querySelector('#wh-widget-send-button').style.display = 'block';
    
    if (window.innerWidth >= 1100) {
      content = querySelector('#dicas-content');
      content.style.zIndex = '0';
      content.style.width = '23%';
      content.style.height = '48%';
      content.style.borderRadius = '5px';
      content.style.left = '51%';
      content.style.top = '1%';

      content = querySelector('#saude-content');
      content.style.zIndex = '0';
      content.style.width = '23%';
      content.style.height = '48%';
      content.style.borderRadius = '5px';
      content.style.left = '75%';
      content.style.top = '51%';

      content = querySelector('#artigos-content');
      content.style.zIndex = '0';
      content.style.width = '23%';
      content.style.height = '48%';
      content.style.borderRadius = '5px';
      content.style.left = '75%';
      content.style.top = '1%';

      content = querySelector('#cuidados-content');
      content.style.zIndex = '0';
      content.style.width = '23%';
      content.style.height = '48%';
      content.style.borderRadius = '5px';
      content.style.left = '51%';
      content.style.top = '51%';
    }

  }
}
