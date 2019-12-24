import '../../../../core/model/collection/collection.dart';
import '../../../../core/model/collection/collection_type.dart';
import '../../../../core/model/field/field.dart';
import '../../../../core/model/field/field_type/field_type.dart';
import '../../../../core/constants/constants.dart';
import 'dentist_quantity_per_shift_by_day_of_week_constants.dart';

class DentistQuantityPerShiftByDayOfWeek extends Collection {
  String _id;
  String _dayOfWeek;
  String _dentistId;
  String _shiftId;
  int _quantity;

  DentistQuantityPerShiftByDayOfWeek(
      this._id, this._dayOfWeek, this._dentistId, this._shiftId, this._quantity)
      : super('', '', null, '', '', null);

  String get id => _id;
  set id(String id) => _id = id;

  String get dayOfWeek => _dayOfWeek;
  set dayOfWeek(String dayOfWeek) => _dayOfWeek = dayOfWeek;

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  String get shiftId => _shiftId;
  set shiftId(String shiftId) => _shiftId = shiftId;

  int get quantity => _quantity;
  set quantity(int quantity) => _quantity = quantity;
}
