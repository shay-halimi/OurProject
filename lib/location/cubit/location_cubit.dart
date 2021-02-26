import 'dart:async';

import 'package:accounts_repository/accounts_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart' as location_location;

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final location_location.Location _location = new location_location.Location();

  StreamSubscription<location_location.LocationData> _listen;

  LocationCubit() : super(LocationState.empty) {
    _listen = _location.onLocationChanged.listen((event) {
      emit(LocationState(Location(event.latitude, event.longitude)));
    });
  }

  @override
  Future<void> close() {
    _listen.cancel();
    return super.close();
  }
}
