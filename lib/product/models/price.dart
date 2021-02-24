import 'package:formz/formz.dart';

enum PriceValidationError { invalid }

class Price extends FormzInput<String, PriceValidationError> {
  const Price.pure() : super.pure('');

  const Price.dirty([String value = '']) : super.dirty(value);

  @override
  PriceValidationError validator(String value) {
    var val = num.tryParse(value);

    return val == null || val < 0 ? null : PriceValidationError.invalid;
  }
}
