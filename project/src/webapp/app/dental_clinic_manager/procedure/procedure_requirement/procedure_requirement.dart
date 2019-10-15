import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'procedure_requirement_constants.dart';

class ProcedureRequirement extends Collection {
  String _id;
  String _procedureId;
  String _requirementId;

  ProcedureRequirement(this._id, this._procedureId, this._requirementId)
      : super('', '', null, '', '', null);

  String get id => _id;
  set id(String id) => _id = id;

  String get procedureId => _procedureId;
  set procedureId(String procedureId) => _procedureId = procedureId;

  String get requirementId => _requirementId;
  set requirementId(String requirementId) => _requirementId = requirementId;
}
