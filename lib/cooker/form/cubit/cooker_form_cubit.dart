import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:location_services/location_services.dart';

part 'cooker_form_state.dart';

class CookerFormCubit extends Cubit<CookerFormState> {
  CookerFormCubit({
    @required Cooker cooker,
    @required CookerBloc cookerBloc,
    @required LocationServices locationServices,
  })  : assert(cooker != null),
        assert(cookerBloc != null),
        assert(locationServices != null),
        _cooker = cooker,
        _cookerBloc = cookerBloc,
        _locationServices = locationServices,
        super(const CookerFormState()) {
    emit(state.copyWith(
      displayNameInput: _cooker.displayName.isEmpty
          ? DisplayNameInput.pure()
          : DisplayNameInput.dirty(_cooker.displayName),
      photoURLInput: _cooker.photoURL.isEmpty
          ? PhotoURLInput.pure()
          : PhotoURLInput.dirty(_cooker.photoURL),
      addressInput: _cooker.address.isEmpty
          ? AddressInput.pure()
          : AddressInput.dirty(_cooker.address),
    ));
  }

  final Cooker _cooker;
  final CookerBloc _cookerBloc;
  final LocationServices _locationServices;

  Future<void> update() async {
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
      final cooker = _cooker.copyWith(
        displayName: state.displayNameInput.value,
        photoURL: state.photoURLInput.value,
        address: state.addressInput.value,
      );

      _cookerBloc.add(CookerUpdatedEvent(cooker));

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> create() async {
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
      final cooker = _cooker.copyWith(
        displayName: state.displayNameInput.value,
        photoURL: state.photoURLInput.value,
        address: state.addressInput.value,
      );

      _cookerBloc.add(CookerCreatedEvent(cooker));

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
