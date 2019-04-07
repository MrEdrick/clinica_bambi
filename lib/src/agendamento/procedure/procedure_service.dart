import 'procedure.dart';

class ProcedureService {
  static Procedure _procedure = null;

  Procedure get procedure => _procedure;
  set procedure(Procedure procedure) => _procedure = procedure;
}