part of 'phone_number_cubit.dart';

class PhoneNumberState extends Equatable {
  const PhoneNumberState({
    this.phoneNumber = const PhoneNumberInput.pure(),
    this.status = FormzStatus.pure,
  });

  final PhoneNumberInput phoneNumber;
  final FormzStatus status;

  @override
  List<Object> get props => [phoneNumber, status];

  PhoneNumberState copyWith({
    PhoneNumberInput phoneNumber,
    FormzStatus status,
  }) {
    return PhoneNumberState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }
}

enum PhoneNumberInputValidationError { invalid }

class PhoneNumberInput
    extends FormzInput<String, PhoneNumberInputValidationError> {
  const PhoneNumberInput.pure() : super.pure('');

  const PhoneNumberInput.dirty([String value = '']) : super.dirty(value);

  static final RegExp _phoneNumberRegExp = RegExp(
    r'^05\d{8}$',
  );

  /// @todo(matan) migrate to https://github.com/google/libphonenumber
  @override
  PhoneNumberInputValidationError validator(String value) {
    return _phoneNumberRegExp.hasMatch(value)
        ? null
        : PhoneNumberInputValidationError.invalid;
  }

  String get e164 => '+972${value.substring(1)}';
}
