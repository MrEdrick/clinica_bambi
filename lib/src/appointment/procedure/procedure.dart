import '../core/model/collection.dart';
import '../core/model/field.dart';
import '../core/model/constants.dart';
import 'procedure_constants.dart';

class Procedure extends Collection {
  String _id;
  String _description;
  bool _state;

  Procedure(this._id, this._description, this._state)
      : super(
            'Procedure',
            '',
            PROCEDURE_COLLECTION_MODEL
                .map((model) => new Field(model[INDEX_DESCRIPTION],
                    model[INDEX_TYPE], "", model[INDEX_TITLE]))
                .toList(),
            'Procedimentos',
            'list_alt');

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  bool get state => _state;
  set state(bool state) => _state = state;
}
