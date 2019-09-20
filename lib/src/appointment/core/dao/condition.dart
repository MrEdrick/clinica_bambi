class Condition {
  String _field;
  String _value;
  String _comparation;

  Condition(this._field, this._value, this._comparation); 

  String get field => _field;
  set field(String field) => _field = field;

  String get value => _value;
  set value(String value) => _value = value;

  String get comparation => _comparation;
  set comparation(String comparation) => _comparation = comparation;
}