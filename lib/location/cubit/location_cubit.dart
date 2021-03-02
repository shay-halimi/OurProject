import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location_services/location_services.dart';
import 'package:meta/meta.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({
    @required LocationServices locationServices,
  })  : assert(locationServices != null),
        _locationServices = locationServices,
        super(const LocationState.unknown()) {
    _locationSubscription =
        _locationServices.onLocationChange.listen((current) {
      if (current == Location.empty) {
        emit(const LocationState.error());
      } else {
        emit(LocationState.located(current));
      }
    });
  }

  final LocationServices _locationServices;
  StreamSubscription<Location> _locationSubscription;

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }

  Future<void> locate() async {
    emit(const LocationState.locating());

    await _locationServices.locate();
  }
}
