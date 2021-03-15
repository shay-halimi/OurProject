import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/points/points.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:location_services/location_services.dart';
import 'package:points_repository/points_repository.dart';

part 'cooker_form_state.dart';

class CookerFormCubit extends Cubit<CookerFormState> {
  CookerFormCubit({
    @required CookerBloc cookerBloc,
    @required PointsBloc pointsBloc,
    @required LocationServices locationServices,
  })  : assert(cookerBloc != null),
        assert(pointsBloc != null),
        assert(locationServices != null),
        _cookerBloc = cookerBloc,
        _pointsBloc = pointsBloc,
        _locationServices = locationServices,
        super(const CookerFormState()) {
    if (_cooker.isNotEmpty) {
      emit(state.copyWith(
        displayNameInput: DisplayNameInput.dirty(_cooker.displayName),
        photoURLInput: PhotoURLInput.dirty(_cooker.photoURL),
        addressInput: AddressInput.dirty(_cooker.address),
      ));
    }
  }

  Cooker get _cooker => _cookerBloc.state.cooker;

  final CookerBloc _cookerBloc;
  final PointsBloc _pointsBloc;
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
      final cooker = _cooker.copyWith(
        displayName: state.displayNameInput.value,
        photoURL: state.photoURLInput.value,
        address: state.addressInput.value,
      );

      _cookerBloc.add(
        _cooker.isEmpty
            ? CookerCreatedEvent(cooker)
            : CookerUpdatedEvent(cooker),
      );

      _pointsBloc.state.points.forEach((point) {
        if (point.latLng.isNotEmpty) {
          _pointsBloc.add(
            PointUpdatedEvent(
              point.copyWith(
                latLng: LatLng(
                  latitude: cooker.address.latitude,
                  longitude: cooker.address.longitude,
                ),
              ),
            ),
          );
        }
      });
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
