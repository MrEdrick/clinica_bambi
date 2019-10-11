import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'convenios-app',
  templateUrl: 'convenios_component.html',
  directives: const [coreDirectives],
  providers: const [materialProviders],
  styleUrls: const [
    'convenios_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class ConveniosComponent {}
