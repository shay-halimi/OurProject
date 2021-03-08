part of 'points_bloc.dart';

enum PointStatus { loading, loaded, error, unknown }

class PointsState extends Equatable {
  const PointsState._({
    this.points = const [],
    this.status = PointStatus.unknown,
  }) : assert(points != null);

  const PointsState.loading() : this._(status: PointStatus.loading);

  const PointsState.loaded([List<Point> points = const []])
      : this._(points: points, status: PointStatus.loaded);

  const PointsState.unknown() : this._(status: PointStatus.unknown);

  const PointsState.error() : this._(status: PointStatus.error);

  final PointStatus status;
  final List<Point> points;

  @override
  List<Object> get props => [status, points];
}
