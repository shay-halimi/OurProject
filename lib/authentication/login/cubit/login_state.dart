part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.phoneNumberInput = const PhoneNumberInput.pure(),
    this.otpInput = const OTPInput.pure(),
    this.verificationId = '',
    this.status = FormzStatus.pure,
  });

  final PhoneNumberInput phoneNumberInput;
  final OTPInput otpInput;
  final String verificationId;
  final FormzStatus status;

  @override
  List<Object> get props =>
      [phoneNumberInput, otpInput, verificationId, status];

  LoginState copyWith({
    PhoneNumberInput phoneNumberInput,
    OTPInput otpInput,
    String verificationId,
    FormzStatus status,
  }) {
    return LoginState(
      phoneNumberInput: phoneNumberInput ?? this.phoneNumberInput,
      otpInput: otpInput ?? this.otpInput,
      verificationId: verificationId ?? this.verificationId,
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

enum OTPInputError { invalid }

class OTPInput extends FormzInput<String, OTPInputError> {
  const OTPInput.pure() : super.pure('');

  const OTPInput.dirty([String value = '']) : super.dirty(value);

  static final _otpRegExp = RegExp(r'^[0-9]{6}$');

  @override
  OTPInputError validator(String value) {
    return _otpRegExp.hasMatch(value) ? null : OTPInputError.invalid;
  }
}
