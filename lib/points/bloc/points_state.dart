part of 'points_bloc.dart';

enum PointsStatus { loading, loaded, unknown, error }

class PointsState extends Equatable {
  const PointsState({
    this.nearbyPoints = const [],
    this.cookPoints = const [],
    this.status = PointsStatus.unknown,
  })  : assert(nearbyPoints != null),
        assert(cookPoints != null);

  final List<Point> nearbyPoints;

  final List<Point> cookPoints;

  final PointsStatus status;

  @override
  List<Object> get props => [nearbyPoints, cookPoints, status];

  PointsState copyWith({
    List<Point> nearbyPoints,
    List<Point> cookPoints,
    PointsStatus status,
  }) {
    return PointsState(
      nearbyPoints: nearbyPoints ?? this.nearbyPoints,
      cookPoints: cookPoints ?? this.cookPoints,
      status: status ?? this.status,
    );
  }
}
