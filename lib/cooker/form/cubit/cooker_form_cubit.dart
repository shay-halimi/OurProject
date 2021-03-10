import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookers_repository/cookers_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

part 'cooker_form_state.dart';

class CookerFormCubit extends Cubit<CookerFormState> {
  CookerFormCubit({
    @required Cooker cooker,
    @required CookersRepository cookersRepository,
  })  : assert(cooker != null),
        assert(cookersRepository != null),
        _cooker = cooker,
        _cookersRepository = cookersRepository,
        super(const CookerFormState()) {
    emit(state.copyWith(
      displayNameInput: DisplayNameInput.dirty(_cooker.displayName),
      photoURLInput: PhotoURLInput.dirty(_cooker.photoURL),
    ));
  }

  final Cooker _cooker;
  final CookersRepository _cookersRepository;

  Future<void> update() async {
    if (!state.status.isValidated) return;

    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    try {
      final cooker = _cooker.copyWith(
        displayName: state.displayNameInput.value,
        photoURL: state.photoURLInput.value,
      );

      await _cookersRepository.update(cooker);

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void changeDisplayName(String value) {
    final displayNameInput = DisplayNameInput.dirty(value);
    emit(state.copyWith(
      displayNameInput: displayNameInput,
      status: Formz.validate([
        displayNameInput,
        state.photoURLInput,
      ]),
    ));
  }

  void changePhotoURL(String value) {
    final photoURLInput = PhotoURLInput.dirty(value);
    emit(state.copyWith(
      photoURLInput: photoURLInput,
      status: Formz.validate([
        state.displayNameInput,
        photoURLInput,
      ]),
    ));
  }
}
