import 'package:cookpoint/foods/foods.dart';

final humanz = const _Humanz();

/// @TODO(Matan) !!! _Humanz class support *only* he_IL
/// @TODO(Matan) make _Humanz international.
class _Humanz {
  const _Humanz();

  String money(Money money, [String symbol = ' ₪']) =>
      '${money.amount.toStringAsFixed(2)}$symbol';

  String phoneNumber(String phoneNumber) {
    try {
      return '0${phoneNumber.substring(4, 6)}'
          '-${phoneNumber.substring(6, 9)}'
          '-${phoneNumber.substring(9)}';
    } on Error {
      return phoneNumber;
    }
  }

  String distance(LatLng from, LatLng to) =>
      from.distanceInKM(to).toStringAsFixed(1);
}
