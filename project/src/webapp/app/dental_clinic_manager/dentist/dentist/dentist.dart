import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'dentist_constants.dart';

class Dentist extends Collection {
  String _id;
  String _name;
  String _code;
  bool _state;

  Dentist(this._id, this._name, this._code, this._state)
      : super('', '', null, '', '', null);

  String get id => _id;
  set id(String id) => _id = id;

  String get name => _name;
  set name(String name) => _name = name;

  String get code => _code;
  set code(String code) => _code = code;

  bool get state => _state;
  set state(bool state) => _state = state;
}
