import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location_services/location_services.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(const MapState.unknown());

  void updateLocation(Location location) {
    emit(const MapState.loading());
    emit(MapState.loaded(location));
  }
}
