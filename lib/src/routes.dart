import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'route_paths.dart' as paths;
import 'login/login_component.template.dart' as login_template;
import 'deshboard/deshboard_component.template.dart' as deshboard_template;
import 'deshboard_appointment/deshboard_appointment_component.template.dart' as deshboard_appointment_template;
import 'auto_deshboard_appointment/auto_deshboard_appointment_component.template.dart' as auto_deshboard_appointment_component_template;
import 'not_found_component.template.dart' as not_found_template;

@Injectable()
class Routes {
  static final _login = new RouteDefinition(
    routePath: paths.login,
    component: login_template.LoginComponentNgFactory,
  );

  static final _deshboard = new RouteDefinition(
    routePath: paths.deshboard,
    component: deshboard_template.DeshboardComponentNgFactory,
  );

  static final _deshboardAppointment = new RouteDefinition(
    routePath: paths.deshboard_appointment,
    component: deshboard_appointment_template.DeshboardAppointmentComponentNgFactory,
  );

  static final _deshboardAutoAppointment = new RouteDefinition(
    routePath: paths.deshboard_auto_appointment,
    component: deshboard_auto_appointment_component_template.DeshboardAutoAppointmentComponentNgFactory,
  );

  static final _not_found_component = new RouteDefinition(
    routePath: paths.not_found,
    component: not_found_template.NotFoundComponentNgFactory,
  );

  final login = _login;
  final deshboard = _deshboard;
  final not_found = _not_found_component;
  final deshboardAppointment = _deshboardAppointment;
  final deshboardAutoAppointment = _deshboardAutoAppointment;

  final List<RouteDefinition> all = [
    _login,
    _deshboard,
    _deshboardAppointment,
    _deshboardAutoAppointment,
    _not_found_component,
    new RouteDefinition.redirect(
      path: '',
      redirectTo: paths.deshboard.toUrl(),
    ),
    new RouteDefinition.redirect(
      path: 'login',
      redirectTo: paths.login.toUrl(),
    ),
    new RouteDefinition(
      path: '.*',
      component: not_found_template.NotFoundComponentNgFactory,
    ),
  ];
}
