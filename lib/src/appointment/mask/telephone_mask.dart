import 'telephone_mask_constants.dart';

class TelephoneMask {
  String _number;

  TelephoneMask(this._number);
  Map<String, dynamic> datas;

  get number => _number;
  set number(String value) {
    _number = '';

    if (value.length == 0) {
      return;
    }

    String valueLocal = '';

    for (var i = 0; i < value.length; i++) {
      if (int.tryParse(value.substring(i, i + 1)) != null) {
        valueLocal = valueLocal + value.substring(i, i + 1);
      }
    }

    if (valueLocal.length >= 11) {
      _number = '(' +
          valueLocal.substring(0, 2) +
          ')' +
          valueLocal.substring(2, 6) +
          '-' +
          valueLocal.substring(6, 10);
      return;
    }

    if (valueLocal.length >= 7) {
      _number = '(' +
          valueLocal.substring(0, 2) +
          ')' +
          valueLocal.substring(2, 6) +
          '-' +
          valueLocal.substring(6);
      return;
    }

    if (valueLocal.length > 2) {
      _number =
          '(' + valueLocal.substring(0, 2) + ')' + valueLocal.substring(2);
      return;
    }

    if (valueLocal.length > 0) {
      _number = '(' + _number + valueLocal.substring(0);
    }
  }
  
}