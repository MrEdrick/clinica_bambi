import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'dentist_procedure_constants.dart';

class DentistProcedure extends Collection {
  String _id;
  String _dentistId;
  String _procedureId;

  DentistProcedure(this._id, this._dentistId, this._procedureId)
      : super('', '', null, '', '', null);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  String get procedureId => _procedureId;
  set procedureId(String procedureId) => _procedureId = procedureId;
}
