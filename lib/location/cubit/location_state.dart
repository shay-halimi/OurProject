part of 'location_cubit.dart';

enum LocationStatus { loading, loaded, unknown, error }

class LocationState extends Equatable {
  const LocationState._({
    this.location = Location.empty,
    this.status = LocationStatus.unknown,
  }) : assert(location != null);

  const LocationState.loading() : this._(status: LocationStatus.loading);

  const LocationState.loaded(Location location)
      : this._(status: LocationStatus.loaded, location: location);

  const LocationState.unknown() : this._(status: LocationStatus.unknown);

  const LocationState.error([Location location = Location.empty])
      : this._(status: LocationStatus.error, location: location);

  final Location location;

  final LocationStatus status;

  @override
  List<Object> get props => [location, status];

  LatLng toLatLng() {
    return LatLng(
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }
}
