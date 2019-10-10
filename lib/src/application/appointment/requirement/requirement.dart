import '../core/model/collection.dart';
import '../core/model/field.dart';
import '../core/model/constants.dart';
import 'requirement_constants.dart';

class Requirement extends Collection {
  String _id;
  String _description;
  bool _state;

  Requirement(this._id, this._description, this._state)
      : super(
            'Requirement',
            '',
            REQUIREMENT_COLLECTION_MODEL
                .map((model) => new Field(model[INDEX_DESCRIPTION],
                    model[INDEX_TYPE], "", model[INDEX_TITLE]))
                .toList(),
            'Requisitos',
            'check_box');

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  bool get state => _state;
  set state(bool state) => _state = state;
}
