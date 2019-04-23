import 'dentist_procedure_by_day_of_week.dart';

class DentistProcedureByDayOfWeekService {
  static DentistProcedureByDayOfWeek _dentistProcedureByDayOfWeek = null;

  DentistProcedureByDayOfWeek get dentistProcedureByDayOfWeek => _dentistProcedureByDayOfWeek;
  set dentistProcedureByDayOfWeek(DentistProcedureByDayOfWeek dentistProcedureByDayOfWeek) => _dentistProcedureByDayOfWeek = dentistProcedureByDayOfWeek;
}