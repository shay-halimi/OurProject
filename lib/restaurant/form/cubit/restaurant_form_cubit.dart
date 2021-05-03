import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

part 'restaurant_form_state.dart';

class RestaurantFormCubit extends Cubit<RestaurantFormState> {
  RestaurantFormCubit({
    @required RestaurantBloc restaurantBloc,
    @required LocationServices locationServices,
  })  : assert(restaurantBloc != null),
        assert(locationServices != null),
        _restaurantBloc = restaurantBloc,
        _locationServices = locationServices,
        super(const RestaurantFormState()) {
    if (_restaurant.isNotEmpty) {
      emit(state.copyWith(
        displayNameInput: DisplayNameInput.dirty(_restaurant.displayName),
        photoURLInput: PhotoURLInput.dirty(_restaurant.photoURL),
        addressInput: AddressInput.dirty(_restaurant.address),
      ));
    }
  }

  Restaurant get _restaurant => _restaurantBloc.state.restaurant;

  final RestaurantBloc _restaurantBloc;

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
      final restaurant = _restaurant.copyWith(
        displayName: state.displayNameInput.value,
        photoURL: state.photoURLInput.value,
        address: state.addressInput.value,
      );

      _restaurantBloc.add(_restaurant.isEmpty
          ? RestaurantCreatedEvent(restaurant)
          : RestaurantUpdatedEvent(restaurant));

      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void changeDisplayName(String value) {
    final displayNameInput = DisplayNameInput.dirty(value.trim());
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
      name: value.trim(),
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
