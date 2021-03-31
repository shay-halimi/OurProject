import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cooks_repository/cooks_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:location_services/location_services.dart';

part 'cook_form_state.dart';

class CookFormCubit extends Cubit<CookFormState> {
  CookFormCubit({
    @required CookBloc cookBloc,
    @required LocationServices locationServices,
  })  : assert(cookBloc != null),
        assert(locationServices != null),
        _cookBloc = cookBloc,
        _locationServices = locationServices,
        super(const CookFormState()) {
    if (_cook.isNotEmpty) {
      emit(state.copyWith(
        displayNameInput: DisplayNameInput.dirty(_cook.displayName),
        photoURLInput: PhotoURLInput.dirty(_cook.photoURL),
        addressInput: AddressInput.dirty(_cook.address),
      ));
    }
  }

  Cook get _cook => _cookBloc.state.cook;

  final CookBloc _cookBloc;
  final LocationServices _locationServices;

  Future<void> save() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final location =
        await _locationServices.fromAddress(state.addressInput.value.name);

    if (location.isEmpty) {
      changeAddress(Address.empty);
    } else {
      changeAddress(state.addressInput.value.copyWith(
        latitude: location.latitude,
        longitude: location.longitude,
      ));
    }

    if (!state.status.isValidated) return;

    try {
      final cook = _cook.copyWith(
        displayName: state.displayNameInput.value,
        photoURL: state.photoURLInput.value,
        address: state.addressInput.value,
      );

      _cookBloc
          .add(_cook.isEmpty ? CookCreatedEvent(cook) : CookUpdatedEvent(cook));

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
        state.addressInput,
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
        state.addressInput,
      ]),
    ));
  }

  void changeAddressName(String value) async {
    changeAddress(Address.empty.copyWith(
      name: value,
    ));
  }

  void changeAddress(Address value) async {
    final addressInput = AddressInput.dirty(value);

    emit(state.copyWith(
      addressInput: addressInput,
      status: Formz.validate([
        state.displayNameInput,
        state.photoURLInput,
        addressInput,
      ]),
    ));
  }
}
