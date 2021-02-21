part of 'otp_cubit.dart';

class OTPState extends Equatable {
  final OTP oneTimePassword;

  final FormzStatus status;

  const OTPState({
    this.oneTimePassword = const OTP.pure(),
    this.status = FormzStatus.pure,
  });

  @override
  List<Object> get props => [oneTimePassword, status];

  OTPState copyWith({
    OTP oneTimePassword,
    FormzStatus status,
  }) {
    return OTPState(
      oneTimePassword: oneTimePassword ?? this.oneTimePassword,
      status: status ?? this.status,
    );
  }
}
