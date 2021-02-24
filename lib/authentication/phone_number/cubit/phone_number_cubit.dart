import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'phone_number_state.dart';

class PhoneNumberCubit extends Cubit<PhoneNumberState> {
  final AuthenticationRepository _authenticationRepository;

  PhoneNumberCubit(this._authenticationRepository)
      : assert(_authenticationRepository != null),
        super(const PhoneNumberState());

  void phoneNumberChanged(String value) {
    final phoneNumber = PhoneNumber.dirty(value);
    emit(state.copyWith(
      phoneNumber: phoneNumber,
      status: Formz.validate([phoneNumber]),
    ));
  }

  Future<void> sendOTP() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      await _authenticationRepository.sendOTP(
        phoneNumber: state.phoneNumber.e164,
      );
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
