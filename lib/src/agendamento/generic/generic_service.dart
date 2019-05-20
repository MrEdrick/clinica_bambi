import '../dentist/dentist_service.dart';
import '../dentist_procedure/dentist_procedure_service.dart';
import '../dentist_procedure_by_day_of_week/dentist_procedure_by_day_of_week_service.dart';
import '../dentist_procedure_by_day_of_week_by_shift/dentist_procedure_by_day_of_week_by_shift_service.dart';
import '../dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week_service.dart';
import '../procedure/procedure_service.dart';
import '../procedure_requirement/procedure_requirement_service.dart';
import '../requirement/requirement_service.dart';
import '../shift/shift_service.dart';

class GenericService {

  void clearAllServicesLists() {
    new DentistService().clearAllDentistList();
    new DentistProcedureService().clearAllDentistProcedureList();
    new DentistProcedureByDayOfWeekService().clearAllDentistProcedureByDayOfWeekList();
    new DentistProcedureByDayOfWeekByShiftService().clearAllDentistProcedureByDayOfWeekByShiftList();
    new DentistQuantityPerShiftByDayOfWeekService().clearAllDentistQuantityPerShiftByDayOfWeekList();
    new ProcedureService().clearAllProcedureList();
    new ProcedureRequirementService().clearAllProcedureRequirementList();
    new RequirementService().clearAllRequirementList();
    new ShiftService().clearAllShiftList();
  }
}