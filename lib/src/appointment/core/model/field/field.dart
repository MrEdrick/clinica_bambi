import '../field_type/field_type.dart';

class Field {
  String _description;
  FieldType _type;
  String _value;
  String _title;

  Field(this._description, this._type, this._value, this._title); 

  String get description => _description;
  set description(String description) => _description = description;

  FieldType get type => _type;
  set type(FieldType type) => _type = type;

  String get value => _value;
  set value(String value) => _value = value;

  String get title => _title;
  set title(String title) => _title = title;
}