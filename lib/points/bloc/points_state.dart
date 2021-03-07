part of 'points_bloc.dart';

enum PointStateStatus { loading, loaded, error, unknown }

class PointsState extends Equatable {
  const PointsState._({
    this.points = const [],
    this.status = PointStateStatus.unknown,
  }) : assert(points != null);

  const PointsState.loading() : this._(status: PointStateStatus.loading);

  const PointsState.loaded([List<Point> points = const []])
      : this._(points: points, status: PointStateStatus.loaded);

  const PointsState.unknown() : this._(status: PointStateStatus.unknown);

  const PointsState.error() : this._(status: PointStateStatus.error);

  final PointStateStatus status;
  final List<Point> points;

  @override
  List<Object> get props => [status, points];
}
