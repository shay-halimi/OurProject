import 'package:formz/formz.dart';

enum TagsValidationError { invalid }

class Tags extends FormzInput<String, TagsValidationError> {
  const Tags.pure() : super.pure('');

  const Tags.dirty([String value = '']) : super.dirty(value);

  @override
  TagsValidationError validator(String value) {
    return null;
  }
}
