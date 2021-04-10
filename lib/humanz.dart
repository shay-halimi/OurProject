import 'package:cookpoint/points/points.dart';

final humanz = _Humanz();

/// @TODO(Matan) !!! _Humanz class support *only* Hebrew
/// @TODO(Matan) make _Humanz international.
class _Humanz {
  String money(Money money) => '${money.amount.toStringAsFixed(2)} ₪';

  String phoneNumber(String phoneNumber) {
    try {
      return '0${phoneNumber.substring(4, 6)}'
          '.${phoneNumber.substring(6, 9)}'
          '.${phoneNumber.substring(9)}';
    } on Error {
      return phoneNumber;
    }
  }

  String distance(LatLng from, LatLng to) =>
      '${from.distanceInKM(to).toStringAsFixed(1)} ק"מ';
}
