class OrderBy {
  String _field;
  String _direction;

  Condition(this._field, this._direction); 

  String get field => _field;
  set field(String field) => _field = field;

  String get direction => _direction;
  set direction(String direction) => _direction = direction;
}