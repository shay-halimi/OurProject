part of 'cooker_form_cubit.dart';

class CookerFormState extends Equatable {
  const CookerFormState({
    this.displayNameInput = const DisplayNameInput.pure(),
    this.photoURLInput = const PhotoURLInput.pure(),
    this.status = FormzStatus.pure,
  });

  final DisplayNameInput displayNameInput;
  final PhotoURLInput photoURLInput;

  final FormzStatus status;

  @override
  List<Object> get props => [
        displayNameInput,
        photoURLInput,
        status,
      ];

  CookerFormState copyWith({
    DisplayNameInput displayNameInput,
    PhotoURLInput photoURLInput,
    FormzStatus status,
  }) {
    return CookerFormState(
      displayNameInput: displayNameInput ?? this.displayNameInput,
      photoURLInput: photoURLInput ?? this.photoURLInput,
      status: status ?? this.status,
    );
  }
}

enum DisplayNameValidationError { invalid }

class DisplayNameInput extends FormzInput<String, DisplayNameValidationError> {
  const DisplayNameInput.pure() : super.pure('');

  const DisplayNameInput.dirty([String value = '']) : super.dirty(value);

  @override
  DisplayNameValidationError validator(String value) {
    return value.length < 60 && !value.contains('\n')
        ? null
        : DisplayNameValidationError.invalid;
  }
}

enum PhotoURLInputValidationError { invalid }

class PhotoURLInput extends FormzInput<String, PhotoURLInputValidationError> {
  const PhotoURLInput.pure() : super.pure('');

  const PhotoURLInput.dirty([String value = '']) : super.dirty(value);

  @override
  PhotoURLInputValidationError validator(String value) {
    return value?.isNotEmpty == true
        ? null
        : PhotoURLInputValidationError.invalid;
  }
}
