import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:formz/formz.dart';

part 'one_time_password_state.dart';

class OneTimePasswordCubit extends Cubit<OneTimePasswordState> {
  final AuthenticationRepository _authenticationRepository;

  OneTimePasswordCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const OneTimePasswordState()) ;

  void oneTimePasswordChanged(String value) {
    final oneTimePassword = OneTimePassword.dirty(value);
    emit(state.copyWith(
      oneTimePassword: oneTimePassword,
      status: Formz.validate([oneTimePassword]),
    ));
  }

  Future<void> confirmPhoneNumber() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      await _authenticationRepository.signInWithCredential(
        oneTimePassword: state.oneTimePassword.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
