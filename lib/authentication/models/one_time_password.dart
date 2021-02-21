import 'package:formz/formz.dart';

enum OneTimePasswordError { invalid }

class OneTimePassword extends FormzInput<String, OneTimePasswordError> {
  const OneTimePassword.pure() : super.pure('');
  const OneTimePassword.dirty([String value = '']) : super.dirty(value);

  static final _oneTimePasswordRegExp =
      RegExp(r'^[0-9]{6}$');

  @override
  OneTimePasswordError validator(String value) {
    return _oneTimePasswordRegExp.hasMatch(value)
        ? null
        : OneTimePasswordError.invalid;
  }
}
