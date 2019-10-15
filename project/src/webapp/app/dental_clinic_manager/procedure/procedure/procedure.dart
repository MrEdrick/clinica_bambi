import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'procedure_constants.dart';

class Procedure extends Collection {
  String _id;
  String _description;
  bool _state;

  Procedure(this._id, this._description, this._state)
      : super(
            PROCEDURE_COLLECTION,
            '',
            [
              new Field(
                  PROCEDURE_FIELD_ID,
                  new FieldType(
                      FIELD_TYPE_PRIMARY_KEY, FIELD_TYPE_VALUE_STRING, false),
                  "",
                  "Id"),
              new Field(
                  PROCEDURE_FIELD_DESCRIPTION,
                  new FieldType(
                      FIELD_TYPE_COMMON, FIELD_TYPE_VALUE_STRING, true),
                  "",
                  "Descrição"),
              new Field(
                  PROCEDURE_FIELD_STATE,
                  new FieldType(
                      FIELD_TYPE_COMMON, FIELD_TYPE_VALUE_BOOLEAN, false),
                  "",
                  "Estado")
            ],
            'Requisitos',
            'check_box',
            new CollectionType(COLLECTION_TYPE_FINAL, true));

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  bool get state => _state;
  set state(bool state) => _state = state;
}
