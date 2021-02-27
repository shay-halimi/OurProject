part of 'otp_cubit.dart';

class OTPState extends Equatable {
  const OTPState({
    this.otp = const OTP.pure(),
    this.status = FormzStatus.pure,
  });

  final OTP otp;
  final FormzStatus status;

  @override
  List<Object> get props => [otp, status];

  OTPState copyWith({
    OTP otp,
    FormzStatus status,
  }) {
    return OTPState(
      otp: otp ?? this.otp,
      status: status ?? this.status,
    );
  }
}
