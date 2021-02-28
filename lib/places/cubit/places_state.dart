part of 'places_cubit.dart';

enum PlacesStateStatus { unknown, locating, located, error }

class PlacesState extends Equatable {
  const PlacesState._({
    this.place = Place.empty,
    this.status = PlacesStateStatus.unknown,
  }) : assert(place != null);

  const PlacesState.locating() : this._(status: PlacesStateStatus.locating);

  const PlacesState.located(Place place)
      : this._(status: PlacesStateStatus.located, place: place);

  const PlacesState.unknown() : this._(status: PlacesStateStatus.unknown);

  const PlacesState.error() : this._(status: PlacesStateStatus.error);

  final PlacesStateStatus status;
  final Place place;

  @override
  List<Object> get props => [status, place];
}
