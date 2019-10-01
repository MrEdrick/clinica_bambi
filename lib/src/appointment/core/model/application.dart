import 'file.dart';

class Application {
  String _description;
  String _id;
  List<File> _fileList;
  String _title;
  String _icon;

  Application(this._description, this._id, this._fileList, this._title, this._icon);

  String get description => _description;
  set description(String description) => _description = description;

  String get id => _id;
  set id(String id) => _id = id;

  List<File> get fileList => _fileList;
  set fileList(List<File> fileList) => _fileList = fileList;

  Map<String, dynamic> get fileMap => new Map<String, dynamic>.fromIterable(
      _fileList.map((file) => [file.title, file.description, file.icon]));

  String get title => _title;
  set title(String title) => _title = title;

  String get icon => _icon;
  set icon(String icon) => _icon = icon;
}
