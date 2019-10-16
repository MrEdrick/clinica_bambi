import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'period_by_shift_by_day_of_week_constants.dart';

class PeriodByShiftByDayOfWeek extends Collection {
  String _id;
  String _shiftId;
  String _dayOfWeek;
  String _description;
  bool _state;

  PeriodByShiftByDayOfWeek(
      this._id, this._shiftId, this._dayOfWeek, this._description, this._state)
      : super('', '', null, '', '', null);

  String get id => _id;
  set id(String id) => _id = id;

  String get shiftId => _shiftId;
  set shiftId(String shiftId) => _shiftId = shiftId;

  String get dayOfWeek => _dayOfWeek;
  set dayOfWeek(String dayOfWeek) => _dayOfWeek = dayOfWeek;

  String get description => _description;
  set description(String description) => _description = description;

  bool get state => _state;
  set state(bool state) => _state = state;
}
