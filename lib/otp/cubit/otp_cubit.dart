import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:formz/formz.dart';

part 'otp_state.dart';

class OTPCubit extends Cubit<OTPState> {
  final AuthenticationRepository _authenticationRepository;

  OTPCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const OTPState()) ;

  void oneTimePasswordChanged(String value) {
    final oneTimePassword = OTP.dirty(value);
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
