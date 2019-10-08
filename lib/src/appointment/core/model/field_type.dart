import 'foreign_key_type.dart';

class FieldType {
  String _primaryType;
  bool _isKey;
  bool _isForeignKey;
  bool _isMainField;
  ForeignKeyType _foreignKeyType;

  FieldType(this._primaryType, this._isKey, this._isForeignKey,
      this._isMainField, this._foreignKeyType);

  String get primaryType => _primaryType;
  set primaryType(String primaryType) => _primaryType = primaryType;

  bool get isKey => _isKey;
  set isKey(bool isKey) => _isKey = isKey;

  bool get isForeignKey => _isForeignKey;
  set isForeignKey(bool isForeignKey) => _isForeignKey = isForeignKey;

  bool get isMainField => _isMainField;
  set isMainField(bool isMainField) => _isMainField = isMainField;

  ForeignKeyType get foreignKeyType => _foreignKeyType;
  set foreignKeyType(ForeignKeyType foreignKeyType) =>
      _foreignKeyType = foreignKeyType;
}
