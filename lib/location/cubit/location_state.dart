part of 'location_cubit.dart';

enum LocationStatus { loading, loaded, unknown, error }

class LocationState extends Equatable {
  const LocationState._({
    Location location = Location.empty,
    this.status = LocationStatus.unknown,
  })  : assert(location != null),
        _location = location;

  const LocationState.loading() : this._(status: LocationStatus.loading);

  const LocationState.loaded(Location location)
      : this._(status: LocationStatus.loaded, location: location);

  const LocationState.unknown() : this._(status: LocationStatus.unknown);

  const LocationState.error() : this._(status: LocationStatus.error);

  final Location _location;

  double get latitude => _location.latitude;

  double get longitude => _location.longitude;

  double get heading => _location.heading;

  LatLng get latLng => LatLng(
        latitude: latitude,
        longitude: longitude,
      );

  final LocationStatus status;

  @override
  List<Object> get props => [_location, status];
}
