import 'field_type.dart';
import 'foreign_key_type.dart';

class ForeignKeyFieldType extends FieldType {
  ForeignKeyType _foreignKeyType;

  ForeignKeyFieldType(String primaryType, this._foreignKeyType)
      : super(primaryType, false);

  ForeignKeyType get foreignKeyType => _foreignKeyType;
  set foreignKeyType(ForeignKeyType foreignKeyType) =>
      _foreignKeyType = foreignKeyType;
}
