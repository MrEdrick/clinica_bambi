import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
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
              new Field(
                  AGREEMENT_FIELD_ID,
                  new FieldType(
                      FIELD_TYPE_PRIMARY_KEY, FIELD_TYPE_VALUE_STRING, false),
                  "",
                  "Id"),
              new Field(
                  AGREEMENT_FIELD_DESCRIPTION,
                  new FieldType(
                      FIELD_TYPE_COMMON, FIELD_TYPE_VALUE_STRING, true),
                  "",
                  "Descrição"),
              new Field(
                  AGREEMENT_FIELD_STATE,
                  new FieldType(
                      FIELD_TYPE_COMMON, FIELD_TYPE_VALUE_BOOLEAN, false),
                  "",
                  "Estado")
            ],
            'Convênios',
            'credit_card',
            new CollectionType(COLLECTION_TYPE_FINAL, true));

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  bool get state => _state;
  set state(bool state) => _state = state;
}
