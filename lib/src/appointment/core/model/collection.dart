import 'field.dart';

class Collection {
  String _description;
  String _id;
  List<Field> _fieldList;
  String _title;
  String _icon;

  Collection(
      this._description, this._id, this._fieldList, this._title, this._icon);

  String get description => _description;
  set description(String description) => _description = description;

  String get id => _id;
  set id(String id) => _id = id;

  List<Field> get fieldList => _fieldList;
  set fieldList(List<Field> fieldList) => _fieldList = fieldList;

  Map<String, dynamic> get fieldMap => new Map<String, dynamic>.fromIterable(
      _fieldList.map((field) => [field.title, field.description, field.value, field.type]));

  String get title => _title;
  set title(String title) => _title = title;

  String get icon => _icon;
  set icon(String icon) => _icon = icon;
}
