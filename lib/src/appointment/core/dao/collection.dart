import 'field.dart';

class Collection {
  String _description;
  String _id;
  List<Field> _fieldList;

  Collection(this._description, this._id, this._fieldList);

  String get description => _description;
  set description(String description) => _description = description;

  String get id => _id;
  set id(String id) => _id = id;

  List<Field> get fieldList => _fieldList;
  set fieldList(List<Field> fieldList) => _fieldList = fieldList;

  Map<String, dynamic> get fieldMap => new Map<String, dynamic>.fromIterable(
      _fieldList.map((field) => [field.description, field.value]));
}
