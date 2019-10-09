import 'field_type.dart';
import 'primary_key_type.dart';

class PrimmaryKeyFieldType extends FieldType {
  PrimaryKeyType _primaryKeyType;

  PrimmaryKeyFieldType(String primaryType, this._primaryKeyType)
      : super(primaryType, false);

  PrimaryKeyType get primaryKeyType => _primaryKeyType;
  set primaryKeyType(PrimaryKeyType primaryKeyType) =>
      _primaryKeyType = primaryKeyType;
}
