part of 'points_bloc.dart';

abstract class PointsEvent extends Equatable {
  const PointsEvent();

  @override
  List<Object> get props => [];
}

class PointsNearbyRequestedEvent extends PointsEvent {
  const PointsNearbyRequestedEvent(
    this.latLng, [
    this.radiusInKM = 100,
  ]);

  final LatLng latLng;

  final double radiusInKM;

  @override
  List<Object> get props => [latLng, radiusInKM];
}

class PointsNearbyLoadedEvent extends PointsEvent {
  PointsNearbyLoadedEvent(this.points);

  final List<Point> points;

  @override
  List<Object> get props => [points];
}

class PointsOfCookRequestedEvent extends PointsEvent {
  const PointsOfCookRequestedEvent(this.cook);

  final Cook cook;

  @override
  List<Object> get props => [cook];
}

class PointsOfCookLoadedEvent extends PointsEvent {
  PointsOfCookLoadedEvent(this.points);

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
