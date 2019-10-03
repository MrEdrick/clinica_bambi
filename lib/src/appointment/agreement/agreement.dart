import '../core/model/collection.dart';
import '../core/model/field.dart';
import '../core/model/constants.dart';
import 'agreement_constants.dart';

class Agreement extends Collection {
  String _id;
  String _description;
  bool _state;

  Agreement(this._id, this._description, this._state)
      : super('Agreement', '',
      AGREEMENT_COLLECTION_MODEL.map((model) => new Field(model[INDEX_DESCRIPTION], model[INDEX_TYPE], "", model[INDEX_TITLE])).toList(), 
            'Convênios', 'credit_card');

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  bool get state => _state;
  set state(bool state) => _state = state;
}
