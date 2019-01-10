import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'textos-saude-app',
  templateUrl: 'textos_saude_component.html',
  directives: const [coreDirectives, materialDirectives],
  providers: const [materialProviders],
  styleUrls: const [
    'textos_saude_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class TextosSaudeComponent {

}
