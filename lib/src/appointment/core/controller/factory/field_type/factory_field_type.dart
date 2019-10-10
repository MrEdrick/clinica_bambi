import '../../../model/primary_key_type.dart';
import '../../../model/field_type.dart';
import '../../../model/primary_key_field_type.dart';
import '../../../model/foreign_key_field_type.dart';
import '../../../model/constants.dart';

class FactoryFieldType {
  String _fieldType;
  Map _mapFieldType;

  FactoryFieldType(this._fieldType, this._mapFieldType);

  FieldType returnFieldType() {
    if (_fieldType == "Common") {
      return new FieldType(
          _mapFieldType[FIELD_TYPE_MODEL_TYPE],
          _mapFieldType[FIELD_TYPE_MODEL_TYPE_VALUE],
          _mapFieldType[FIELD_TYPE_MODEL_IS_MAIN_FIELD]);
    }
    if (_fieldType == "PrimaryKey") {
      return new PrimmaryKeyFieldType(_mapFieldType[FIELD_TYPE_MODEL_TYPE], new PrimaryKeyType(_mapFieldType[FIELD_TYPE_MODEL_KEY_MODEL][PRIMARY_KEY_TYPE_MODEL_IS_COMPOSED]))
    }
    if (_fieldType == "ForeignKey") {}
  }
}
