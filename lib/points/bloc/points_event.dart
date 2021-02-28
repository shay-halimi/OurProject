part of 'points_bloc.dart';

abstract class PointsEvent extends Equatable {
  const PointsEvent();

  @override
  List<Object> get props => [];
}

class PointsLoadedEvent extends PointsEvent {
  const PointsLoadedEvent(this.points);

  final List<Point> points;

  @override
  List<Object> get props => [points];
}

class PointSubscribedEvent extends PointsEvent {
  const PointSubscribedEvent(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}

class PointCreatedEvent extends PointsEvent {
  const PointCreatedEvent(this.point);

  final Point point;

  @override
  List<Object> get props => [point];
}

class PointUpdatedEvent extends PointsEvent {
  const PointUpdatedEvent(this.point);

  final Point point;

  @override
  List<Object> get props => [point];
}
