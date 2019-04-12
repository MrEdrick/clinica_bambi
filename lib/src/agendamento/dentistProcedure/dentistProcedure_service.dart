import 'dentistProcedure.dart';

class DentistProcedureService {
  static DentistProcedure _dentistProcedure = null;

  DentistProcedure get dentistProcedure => _dentistProcedure;
  set dentistProcedure(DentistProcedure dentistProcedure) => _dentistProcedure = dentistProcedure;
}