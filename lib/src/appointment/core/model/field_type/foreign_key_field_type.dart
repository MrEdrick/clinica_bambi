import 'field_type.dart';
import '../key_type/foreign_key_type.dart';

class ForeignKeyFieldType extends FieldType {
  ForeignKeyType _foreignKeyType;

  ForeignKeyFieldType(String valueType, this._foreignKeyType)
      : super("foreignKey", valueType, false);

  ForeignKeyType get foreignKeyType => _foreignKeyType;
  set foreignKeyType(ForeignKeyType foreignKeyType) =>
      _foreignKeyType = foreignKeyType;
}
