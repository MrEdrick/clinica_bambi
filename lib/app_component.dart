import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'src/routes.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  directives: const [
    coreDirectives,
    RouterOutlet,
    routerDirectives
  ],
  providers: const [materialProviders, ClassProvider(Routes)],
  styleUrls: const [
    'app_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class AppComponent {
  final Routes routes;


  AppComponent(this.routes);
}
