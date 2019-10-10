import '../core/model/collection.dart';
import '../core/model/field/field.dart';
import '../core/model/field_type/field_type.dart';
import '../core/model/constants.dart';
import 'agreement_constants.dart';

class Agreement extends Collection {
  String _id;
  String _description;
  bool _state;

  Agreement(this._id, this._description, this._state)
      : super(
            AGREEMENT_COLLECTION,
            '',
            [
              new Field(AGREEMENT_ID_FIELD,
                  new FieldType("primaryType", FIELD_TYPE_STRING, false), "", "Id"),
              new Field(
                  AGREEMENT_DESCRIPTION_FIELD,
                  new FieldType("common", FIELD_TYPE_STRING, true),
                  "",
                  "Descrição"),
              new Field(AGREEMENT_STATE_FIELD, new FieldType("common", FIELD_TYPE_BOOLEAN, false),
                 "", "Estado")
            ],
            'Convênios',
            'credit_card');

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  bool get state => _state;
  set state(bool state) => _state = state;
}
