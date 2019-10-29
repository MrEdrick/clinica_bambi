import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'dentist_procedure_by_day_of_week_by_shift_constants.dart';

class DentistProcedureByDayOfWeekByShift extends Collection {
  String _id;
  String _dentistProcedureByDayOfWeekId;
  String _shiftId;

  DentistProcedureByDayOfWeekByShift(
      this._id, this._dentistProcedureByDayOfWeekId, this._shiftId)
      : super('', '', null, '', '', null);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistProceddentistProcedureByDayOfWeekIdureId =>
      _dentistProcedureByDayOfWeekId;
  set dentistProcedureByDayOfWeekId(String dentistProcedureByDayOfWeekId) =>
      _dentistProcedureByDayOfWeekId = dentistProcedureByDayOfWeekId;

  String get shiftId => _shiftId;
  set shiftId(String shiftId) => _shiftId = shiftId;
}
