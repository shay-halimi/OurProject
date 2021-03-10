import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'otp_state.dart';

class OTPCubit extends Cubit<OTPState> {
  OTPCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const OTPState());

  final AuthenticationRepository _authenticationRepository;

  void otpChanged(String value) {
    final otp = OTPInput.dirty(value);
    emit(state.copyWith(
      otp: otp,
      status: Formz.validate([otp]),
    ));
  }

  Future<void> confirmPhoneNumber() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      await _authenticationRepository.signInWithCredential(
        otp: state.otp.value,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
