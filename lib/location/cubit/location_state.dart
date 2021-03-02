part of 'location_cubit.dart';

enum LocationStateStatus { unknown, locating, located, error }

class LocationState extends Equatable {
  const LocationState._({
    this.current = Location.empty,
    this.status = LocationStateStatus.unknown,
  }) : assert(current != null);

  const LocationState.unknown() : this._(status: LocationStateStatus.unknown);

  const LocationState.locating() : this._(status: LocationStateStatus.locating);

  const LocationState.located(Location current)
      : this._(
          status: LocationStateStatus.located,
          current: current,
        );

  const LocationState.error() : this._(status: LocationStateStatus.error);

  final LocationStateStatus status;
  final Location current;

  @override
  List<Object> get props => [status, current];
}
