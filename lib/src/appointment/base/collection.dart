import 'field.dart';

class Collection {
  String _description;
  List<Field> _fieldList;

  Collection(this._description, this._fieldList);

  String get description => _description;
  set description(String description) => _description = description;

  List<Field> get fieldList => _fieldList;
  set fieldList(List<Field> fieldList) => _fieldList = fieldList;

}