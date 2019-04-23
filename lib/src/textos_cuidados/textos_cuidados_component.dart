import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'textos-cuidados-app',
  templateUrl: 'textos_cuidados_component.html',
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: const [coreDirectives],
  providers: const [materialProviders],
  styleUrls: const [
    'textos_cuidados_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class TextosCuidadosComponent {

}
