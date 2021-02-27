part of 'location_cubit.dart';

enum LocationStateStatus { unknown, locating, located, error }

class LocationState extends Equatable {
  const LocationState._({
    this.location = Location.empty,
    this.status = LocationStateStatus.unknown,
  }) : assert(location != null);

  const LocationState.locating() : this._(status: LocationStateStatus.locating);

  const LocationState.located(Location location)
      : this._(status: LocationStateStatus.located, location: location);

  const LocationState.unknown() : this._(status: LocationStateStatus.unknown);

  const LocationState.error() : this._(status: LocationStateStatus.error);

  final LocationStateStatus status;
  final Location location;

  @override
  List<Object> get props => [status, location];
}
