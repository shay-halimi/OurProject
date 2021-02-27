part of 'map_cubit.dart';

class MapState extends Equatable {
  const MapState({
    this.position = Location.empty,
  }) : assert(position != null);

  final Location position;

  @override
  List<Object> get props => [position];
}
