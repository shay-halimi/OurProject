part of 'restaurant_form_cubit.dart';

class RestaurantFormState extends Equatable {
  const RestaurantFormState({
    this.displayNameInput = const DisplayNameInput.pure(),
    this.photoURLInput = const PhotoURLInput.pure(),
    this.aboutInput = const AboutInput.pure(),
    this.addressInput = const AddressInput.pure(),
    this.status = FormzStatus.pure,
  });

  final DisplayNameInput displayNameInput;

  final PhotoURLInput photoURLInput;

  final AboutInput aboutInput;

  final AddressInput addressInput;

  final FormzStatus status;

  @override
  List<Object> get props => [
        displayNameInput,
        photoURLInput,
        aboutInput,
        addressInput,
        status,
      ];

  RestaurantFormState copyWith({
    DisplayNameInput displayNameInput,
    PhotoURLInput photoURLInput,
    AboutInput aboutInput,
    AddressInput addressInput,
    FormzStatus status,
  }) {
    return RestaurantFormState(
      displayNameInput: displayNameInput ?? this.displayNameInput,
      photoURLInput: photoURLInput ?? this.photoURLInput,
      aboutInput: aboutInput ?? this.aboutInput,
      addressInput: addressInput ?? this.addressInput,
      status: status ?? this.status,
    );
  }
}

enum DisplayNameValidationError { invalid }

class DisplayNameInput extends FormzInput<String, DisplayNameValidationError> {
  const DisplayNameInput.pure() : super.pure('');

  const DisplayNameInput.dirty([String value = '']) : super.dirty(value);

  int get minLength => 1;

  int get maxLength => 32;

  @override
  DisplayNameValidationError validator(String value) {
    return (value.length > minLength &&
            value.length < maxLength &&
            !value.contains('\n'))
        ? null
        : DisplayNameValidationError.invalid;
  }
}

enum PhotoURLInputValidationError { invalid }

class PhotoURLInput extends FormzInput<String, PhotoURLInputValidationError> {
  const PhotoURLInput.pure() : super.pure(defaultPhotoURL);

  const PhotoURLInput.dirty([String value = '']) : super.dirty(value);

  static const defaultPhotoURL =
      'https://firebasestorage.googleapis.com/v0/b/cookpoint-e16ce.appspot.com/o/logo.png?alt=media&token=7566ed32-d1d1-47ec-ae2c-3d805f38f935';

  @override
  PhotoURLInputValidationError validator(String value) {
    final uri = Uri.tryParse(value);

    if (uri != null && (uri.isScheme('http') || uri.isScheme('https'))) {
      return null;
    }

    return PhotoURLInputValidationError.invalid;
  }
}

enum AboutInputValidationError { invalid }

class AboutInput extends FormzInput<String, AboutInputValidationError> {
  const AboutInput.pure() : super.pure('');

  const AboutInput.dirty([String value = '']) : super.dirty(value);

  int get maxLength => 256;

  @override
  AboutInputValidationError validator(String value) {
    if (value.length < maxLength) {
      return null;
    }

    return AboutInputValidationError.invalid;
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
