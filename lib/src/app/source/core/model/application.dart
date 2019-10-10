import 'archive.dart';

class Application {
  String _description;
  String _id;
  List<Archive> _archiveList;
  String _title;
  String _icon;

  Application(this._description, this._id, this._archiveList, this._title, this._icon);

  String get description => _description;
  set description(String description) => _description = description;

  String get id => _id;
  set id(String id) => _id = id;

  List<Archive> get archiveList => _archiveList;
  set archiveList(List<Archive> archiveList) => _archiveList = archiveList;

  Map<String, dynamic> get archiveMap => new Map<String, dynamic>.fromIterable(
      _archiveList.map((archive) => [archive.title, archive.description, archive.icon]));

  String get title => _title;
  set title(String title) => _title = title;

  String get icon => _icon;
  set icon(String icon) => _icon = icon;
}
