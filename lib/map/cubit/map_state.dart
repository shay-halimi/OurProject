part of 'map_cubit.dart';

enum MapStateStatus { unknown, loading, loaded }

class MapState extends Equatable {
  const MapState._({
    this.location = Location.empty,
    this.status = MapStateStatus.unknown,
  }) : assert(location != null);

  const MapState.unknown() : this._(status: MapStateStatus.unknown);

  const MapState.loading() : this._(status: MapStateStatus.loading);

  const MapState.loaded(Location location)
      : this._(status: MapStateStatus.loaded, location: location);

  final MapStateStatus status;
  final Location location;

  @override
  List<Object> get props => [status, location];
}
