part of 'cooker_form_cubit.dart';

class CookerFormState extends Equatable {
  const CookerFormState({
    this.displayNameInput = const DisplayNameInput.pure(),
    this.photoURLInput = const PhotoURLInput.pure(),
    this.addressInput = const AddressInput.pure(),
    this.status = FormzStatus.pure,
  });

  final DisplayNameInput displayNameInput;
  final PhotoURLInput photoURLInput;
  final AddressInput addressInput;

  final FormzStatus status;

  @override
  List<Object> get props => [
        displayNameInput,
        photoURLInput,
        addressInput,
        status,
      ];

  CookerFormState copyWith({
    DisplayNameInput displayNameInput,
    PhotoURLInput photoURLInput,
    AddressInput addressInput,
    FormzStatus status,
  }) {
    return CookerFormState(
      displayNameInput: displayNameInput ?? this.displayNameInput,
      photoURLInput: photoURLInput ?? this.photoURLInput,
      addressInput: addressInput ?? this.addressInput,
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
    return (value.length > 1 && value.length < 50 && !value.contains('\n'))
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
    final uri = Uri.tryParse(value);

    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      return null;
    }

    return PhotoURLInputValidationError.invalid;
  }
}

enum AddressInputValidationError { invalid }

class AddressInput extends FormzInput<Address, AddressInputValidationError> {
  const AddressInput.pure() : super.pure(Address.empty);

  const AddressInput.dirty([Address value = Address.empty])
      : super.dirty(value);

  @override
  AddressInputValidationError validator(Address value) {
    return value.isNotEmpty ? null : AddressInputValidationError.invalid;
  }
}
