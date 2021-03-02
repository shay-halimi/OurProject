import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location_services/location_services.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapState.unknown());

  StreamSubscription<Location> _currentSubscription;

  @override
  Future<void> close() {
    _currentSubscription?.cancel();
    return super.close();
  }

  Future<void> focus(Location location) async {
    emit(MapState.loaded(location));
  }
}
