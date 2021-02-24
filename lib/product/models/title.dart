import 'package:formz/formz.dart';

enum TitleValidationError { invalid }

class Title extends FormzInput<String, TitleValidationError> {
  const Title.pure() : super.pure('');

  const Title.dirty([String value = '']) : super.dirty(value);

  @override
  TitleValidationError validator(String value) {
    return value.length > 60 && !value.contains('\n')
        ? null
        : TitleValidationError.invalid;
  }
}
