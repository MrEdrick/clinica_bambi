import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'shift_constants.dart';

class Shift extends Collection {
  String _id;
  String _description;
  String _observation;
  int _startTime;
  bool _state;

  Shift(this._id, this._description, this._observation, this._startTime,
      this._state)
      : super(
            SHIFT_COLLECTION,
            '',
            [
              new Field(
                  SHIFT_FIELD_ID,
                  new FieldType(
                      FIELD_TYPE_PRIMARY_KEY, FIELD_TYPE_VALUE_STRING, false),
                  "",
                  "Id"),
              new Field(
                  SHIFT_FIELD_DESCRIPTION,
                  new FieldType(
                      FIELD_TYPE_COMMON, FIELD_TYPE_VALUE_STRING, true),
                  "",
                  "Descrição"),
              new Field(
                  SHIFT_FIELD_STATE,
                  new FieldType(
                      FIELD_TYPE_COMMON, FIELD_TYPE_VALUE_BOOLEAN, false),
                  "",
                  "Estado")
            ],
            'Turno',
            'credit_card',
            new CollectionType(COLLECTION_TYPE_FINAL, true));

  String get id => _id;
  set id(String id) => _id = id;

  String get description => _description;
  set description(String description) => _description = description;

  String get observation => _observation;
  set observation(String observation) => _observation = observation;

  int get startTime => _startTime;
  set startTime(int startTime) => _startTime = startTime;

  bool get state => _state;
  set state(bool state) => _state = state;
}
