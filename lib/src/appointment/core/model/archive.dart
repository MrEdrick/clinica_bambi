import 'collection.dart';

class Archive {
  String _description;
  String _id;
  List<Collection> _collectionList;
  String _title;
  String _icon;

  Archive(this._description, this._id, this._collectionList, this._title, this._icon);

  String get description => _description;
  set description(String description) => _description = description;

  String get id => _id;
  set id(String id) => _id = id;

  List<Collection> get collectionList => _collectionList;
  set collectionList(List<Collection> collectionList) => _collectionList = collectionList;

  Map<String, dynamic> get collectionMap => new Map<String, dynamic>.fromIterable(
      _collectionList.map((collection) => [collection.title, collection.description, collection.icon]));

  String get title => _title;
  set title(String title) => _title = title;

  String get icon => _icon;
  set icon(String icon) => _icon = icon;
}
