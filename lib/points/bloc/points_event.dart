part of 'points_bloc.dart';

abstract class PointsEvent extends Equatable {
  const PointsEvent();

  @override
  List<Object> get props => [];
}

class PointsRequestedEvent extends PointsEvent {
  const PointsRequestedEvent(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [latitude, longitude];
}

class PointsLoadedEvent extends PointsEvent {
  const PointsLoadedEvent(this.points);

  final List<Point> points;

  @override
  List<Object> get props => [points];
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

class PointDeletedEvent extends PointsEvent {
  const PointDeletedEvent(this.point);

  final Point point;

  @override
  List<Object> get props => [point];
}
