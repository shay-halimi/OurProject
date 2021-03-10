part of 'otp_cubit.dart';

class OTPState extends Equatable {
  const OTPState({
    this.otp = const OTPInput.pure(),
    this.status = FormzStatus.pure,
  });

  final OTPInput otp;
  final FormzStatus status;

  @override
  List<Object> get props => [otp, status];

  OTPState copyWith({
    OTPInput otp,
    FormzStatus status,
  }) {
    return OTPState(
      otp: otp ?? this.otp,
      status: status ?? this.status,
    );
  }
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
