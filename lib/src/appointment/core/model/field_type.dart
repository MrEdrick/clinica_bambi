class FieldType {
  String _type;
  String _valueType;
  bool _isMainField;

  FieldType(this._type, this._valueType, this._isMainField);

  String get type => _type;
  set type(String type) => _type = type;

  String get valueType => _valueType;
  set valueType(String valueType) => _valueType = valueType;

  bool get isMainField => _isMainField;
  set isMainField(bool isMainField) => _isMainField = isMainField;
}
