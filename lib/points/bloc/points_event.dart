part of 'points_bloc.dart';

abstract class PointsEvent extends Equatable {
  const PointsEvent();

  @override
  List<Object> get props => [];
}

class PointsRequestedEvent extends PointsEvent {
  const PointsRequestedEvent(this.latLng);

  final LatLng latLng;

  @override
  List<Object> get props => [latLng];
}

class PointsOfCookerRequestedEvent extends PointsEvent {
  const PointsOfCookerRequestedEvent(this.cookerId);

  final String cookerId;

  @override
  List<Object> get props => [cookerId];
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
