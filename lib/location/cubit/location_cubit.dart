import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location_repository/location_repository.dart';
import 'package:meta/meta.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit({
    @required LocationRepository locationRepository,
  })  : assert(locationRepository != null),
        _locationRepository = locationRepository,
        super(const LocationState.unknown()) {
    _locationSubscription = _locationRepository.current().listen((event) {
      emit(LocationState.located(event));
    });
  }

  final LocationRepository _locationRepository;

  StreamSubscription<Location> _locationSubscription;

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }

  Future<void> locate() async {
    emit(const LocationState.locating());

    try {
      await _locationRepository.locate();
    } on LocateFailure {
      emit(const LocationState.error());
    }
  }
}
