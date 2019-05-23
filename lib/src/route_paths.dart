import 'package:angular_router/angular_router.dart';

final login = new RoutePath(path: 'login');
final deshboard = new RoutePath(path: 'deshboard');
final deshboard_appointment = new RoutePath(path: 'deshboard_appointment');
final deshboard_auto_appointment = new RoutePath(path: 'auto_deshboard_appointment');
final not_found = new RoutePath(path: 'not_found');
final idParam = 'id';
//final hero = new RoutePath(path: '${heroes.path}/:$idParam');

int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
