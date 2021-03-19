import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void phoneNumberChanged(String value) {
    final input = PhoneNumberInput.dirty(value);
    emit(state.copyWith(
      phoneNumberInput: input,
      status: Formz.validate([input]),
    ));
  }

  void otpChanged(String value) {
    final input = OTPInput.dirty(value);
    emit(state.copyWith(
      otpInput: input,
      status: Formz.validate([input]),
    ));
  }

  void clearVerification() {
    emit(state.copyWith(
      verification: Verification.empty,
      status: FormzStatus.submissionSuccess,
    ));
  }

  Future<void> sendOTP() async {
    if (state.phoneNumberInput.invalid) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final verification = await _authenticationRepository.sendOTP(
        phoneNumber: state.phoneNumberInput.e164,
      );

      await Future.delayed(Duration(seconds: 1));

      emit(state.copyWith(
        verification: verification,
        status: FormzStatus.submissionSuccess,
      ));
    } catch (e) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> confirmPhoneNumber() async {
    if (state.otpInput.invalid) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      await _authenticationRepository.signIn(
        otp: state.otpInput.value,
        verification: state.verification,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
