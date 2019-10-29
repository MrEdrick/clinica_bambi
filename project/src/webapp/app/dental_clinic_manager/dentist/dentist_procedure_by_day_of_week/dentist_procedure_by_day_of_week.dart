import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'dentist_procedure_by_day_of_week_constants.dart';

class DentistProcedureByDayOfWeek extends Collection {
  String _id;
  String _dentistProcedureId;
  String _dayOfWeek;

  DentistProcedureByDayOfWeek(
      this._id, this._dentistProcedureId, this._dayOfWeek)
      : super('', '', null, '', '', null);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistProcedureId => _dentistProcedureId;
  set dentistProcedureId(String dentistProcedureId) =>
      _dentistProcedureId = dentistProcedureId;

  String get dayOfWeek => _dayOfWeek;
  set dayOfWeek(String dayOfWeek) => _dayOfWeek = dayOfWeek;
}
