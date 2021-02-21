import 'package:formz/formz.dart';

enum PhoneNumberValidationError { invalid }

class PhoneNumber extends FormzInput<String, PhoneNumberValidationError> {
  const PhoneNumber.pure() : super.pure('');

  const PhoneNumber.dirty([String value = '']) : super.dirty(value);

  static final RegExp _phoneNumberRegExp = RegExp(
    r'^05\d{8}$',
  );

  /// @todo(matan) migrate to https://github.com/google/libphonenumber
  @override
  PhoneNumberValidationError validator(String value) {
    return _phoneNumberRegExp.hasMatch(value)
        ? null
        : PhoneNumberValidationError.invalid;
  }

  String get e164 => '+972' + value.substring(1);
}
