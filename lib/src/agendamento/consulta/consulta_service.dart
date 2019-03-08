import 'consulta.dart';

class ConsultaService {
  static Consulta _consulta;

  Consulta get consulta => _consulta;
  set consulta(Consulta consulta) => _consulta = consulta;
}