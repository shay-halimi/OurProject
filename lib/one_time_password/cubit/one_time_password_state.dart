part of 'one_time_password_cubit.dart';

class OneTimePasswordState extends Equatable {
  final OneTimePassword oneTimePassword;

  final FormzStatus status;

  const OneTimePasswordState({
    this.oneTimePassword = const OneTimePassword.pure(),
    this.status = FormzStatus.pure,
  });

  @override
  List<Object> get props => [oneTimePassword, status];

  OneTimePasswordState copyWith({
    OneTimePassword oneTimePassword,
    FormzStatus status,
  }) {
    return OneTimePasswordState(
      oneTimePassword: oneTimePassword ?? this.oneTimePassword,
      status: status ?? this.status,
    );
  }
}
