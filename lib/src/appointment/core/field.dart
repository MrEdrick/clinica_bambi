class Field {
  String _description;
  String _type;
  String _value;

  Field(this._description, this._type, this._value); 

  String get description => _description;
  set description(String description) => _description = description;

  String get type => _type;
  set type(String type) => _type = type;

  String get value => _value;
  set value(String value) => _value = value;
}