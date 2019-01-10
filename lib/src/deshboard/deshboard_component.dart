import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/app_layout/material_persistent_drawer.dart';
import 'package:angular_components/app_layout/material_temporary_drawer.dart';
import 'package:angular_components/content/deferred_content.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';

import '../a_clinica/a_clinica_component.dart';
import '../agendamento/agendamento_component.dart';
import '../dicas/dicas_component.dart';
import '../especialidades/especialidades_component.dart';
import '../convenios/convenios_component.dart';
import '../galeria/galeria_component.dart';

@Component(
  selector: 'deshboard-app',
  templateUrl: 'deshboard_component.html',
  directives: const [
    coreDirectives,
    DeferredContentDirective,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialPersistentDrawerDirective,
    MaterialTemporaryDrawerComponent,
    MaterialToggleComponent,
    AClinicaCmponent,
    AgendamentoComponent,
    DicasComponent,
    EspecialidadesComponent,
    GaleriaComponent,
    ConveniosComponent,
    DeferredContentDirective,
    MaterialIconComponent,
    MaterialTemporaryDrawerComponent,
    MaterialToggleComponent,
    MaterialListComponent,
    MaterialListItemComponent
  ],
  providers: const [materialProviders],
  styleUrls: const [
    'deshboard_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DeshboardComponent implements OnInit {
  bool customWidth = false;
  bool end = false;
  bool overlay = false;

  @override
  ngOnInit() async {
  }

  void clickAClinica() {
    smoothScrolling('a-clinica-app', offset: 0, duration: 500);
  }

  void clickAgenda() {
    smoothScrolling('agendamento-app', offset: 0, duration: 500);
  }

  void clickEspecialidades() {
    smoothScrolling('especialidades-app', offset: 0, duration: 500);
  }

  void clickDicas() {
    smoothScrolling('dicas-app', offset: 0, duration: 500);
  }

  void clickConvenios() {
    smoothScrolling('convenios-app', offset: 0, duration: 500);
  }

  void clickGaleria() {
    smoothScrolling('galeria-app', offset: 0, duration: 500);
  }

  void smoothScrolling(String selector, {int offset: 0, int duration: 500}) {

    int targetPosition = querySelector(selector).offsetTop;

    targetPosition += offset;

    int totalFrames = (duration / (1000 / 60)).round();

    int currentFrame = 0;

    int currentPosition = window.scrollY;

    int distanceBetween = targetPosition - currentPosition;

    num distancePerFrame = distanceBetween / totalFrames;

    void animation(num frame) {
      if (totalFrames >= currentFrame) {
        querySelector('deshboard-app').scrollTo(0, currentPosition);
        currentPosition += distancePerFrame.round();
        currentFrame++;
        window.animationFrame.then(animation);
      }
    }

    window.animationFrame.then(animation);
  }

}
