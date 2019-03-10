import 'package:angular_router/angular_router.dart';

final login = new RoutePath(path: 'login');
final deshboard = new RoutePath(path: 'deshboard');
final deshboard_agendamento = new RoutePath(path: 'agendamento');
final deshboard_auto_agendamento = new RoutePath(path: 'auto_agendamento');
final not_found = new RoutePath(path: 'not_found');
final idParam = 'id';
//final hero = new RoutePath(path: '${heroes.path}/:$idParam');

int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
