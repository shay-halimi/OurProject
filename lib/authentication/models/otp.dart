import 'package:formz/formz.dart';

enum OTPError { invalid }

class OTP extends FormzInput<String, OTPError> {
  const OTP.pure() : super.pure('');

  const OTP.dirty([String value = '']) : super.dirty(value);

  static final _otpRegExp = RegExp(r'^[0-9]{6}$');

  @override
  OTPError validator(String value) {
    return _otpRegExp.hasMatch(value) ? null : OTPError.invalid;
  }
}
