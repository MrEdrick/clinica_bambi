class Procedure {
  String _id;
  String _description;

  Procedure( this._id, this._description);

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

}
