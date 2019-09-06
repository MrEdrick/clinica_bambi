class Field {
  String _description;
  String _type;

  Field(this._description, this._type); 

  String get description => _description;
  set description(String description) => _description = description;

  String get type => _type;
  set type(String type) => _type = type;

}