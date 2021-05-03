import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cookpoint/foods/foods.dart';
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
        _locationServices.onLocationChange.listen((location) {
      if (location.isEmpty) {
        emit(LocationState.error(_getDefaultLocation()));
      } else {
        emit(LocationState.loaded(location));
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

  Future<void> locate([bool openSettings = false]) async {
    emit(const LocationState.loading());

    await _locationServices.locate(openSettings);
  }

  Location _getDefaultLocation() {
    return const Location(32.0853, 34.7818);
  }
}
