part of 'location_cubit.dart';

enum LocationStatus { unknown, locating, located, error }

class LocationState extends Equatable {
  const LocationState._({
    this.current = Location.empty,
    this.status = LocationStatus.unknown,
  }) : assert(current != null);

  const LocationState.unknown() : this._(status: LocationStatus.unknown);

  const LocationState.locating() : this._(status: LocationStatus.locating);

  const LocationState.located(Location current)
      : this._(
          status: LocationStatus.located,
          current: current,
        );

  const LocationState.error() : this._(status: LocationStatus.error);

  final LocationStatus status;
  final Location current;

  @override
  List<Object> get props => [status, current];
}
