class Field {
  String _description;
  String _type;
  String _value;
  String _title;

  Field(this._description, this._type, this._value, this._title); 

  String get description => _description;
  set description(String description) => _description = description;

  String get type => _type;
  set type(String type) => _type = type;

  String get value => _value;
  set value(String value) => _value = value;

  String get title => _title;
  set title(String title) => _title = title;
}