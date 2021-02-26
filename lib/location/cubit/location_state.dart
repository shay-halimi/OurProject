part of 'location_cubit.dart';

class LocationState extends Equatable {
  final Location location;

  const LocationState(this.location);

  @override
  List<Object> get props => [location];

  static const empty = LocationState(Location.empty);
}
