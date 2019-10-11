import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'routes/routes.dart';

@Component(
  selector: 'project-component',
  template: '<router-outlet [routes]="routes.all"></router-outlet>',
  directives: const [
    coreDirectives,
    RouterOutlet,
    routerDirectives
  ],
  providers: const [materialProviders, ClassProvider(Routes)],
  styleUrls: const [
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class ProjectComponent {
  final Routes routes;


  ProjectComponent(this.routes);
}
