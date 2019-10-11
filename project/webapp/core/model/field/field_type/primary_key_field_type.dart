import 'field_type.dart';
import '../key_type/primary_key_type.dart';

class PrimmaryKeyFieldType extends FieldType {
  PrimaryKeyType _primaryKeyType;

  PrimmaryKeyFieldType(String valueType, this._primaryKeyType)
      : super("primaryKey", valueType, false);

  PrimaryKeyType get primaryKeyType => _primaryKeyType;
  set primaryKeyType(PrimaryKeyType primaryKeyType) =>
      _primaryKeyType = primaryKeyType;
}
