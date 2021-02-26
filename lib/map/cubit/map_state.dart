part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState._({
    this.location = Location.empty,
  }) : assert(location != null);

  const MapState.empty() : this._();

  const MapState.found(location) : this._(location: location);

  final Location location;

  @override
  List<Object> get props => [location];
}
