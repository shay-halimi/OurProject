import 'package:formz/formz.dart';

enum photoURLError { invalid }

// ignore: camel_case_types
class photoURL extends FormzInput<String, photoURLError> {
  const photoURL.pure() : super.pure('');

  const photoURL.dirty([String value = '']) : super.dirty(value);

  @override
  photoURLError validator(String value) {
    /// todo check for url.
    return null;
  }
}
