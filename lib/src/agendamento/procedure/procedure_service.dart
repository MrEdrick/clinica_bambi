import 'procedure.dart';

class ProcedureService {
  static Procedure _procedure = null;

  Procedure get procedure => _procedure;
  set procedure(Procedure procedure) => _procedure = procedure;

  Future<Procedure> _turnInProcedure(Map map) async {
    return new Procedure(
        map["id"], map["description"], map["state"]);
  }
}
