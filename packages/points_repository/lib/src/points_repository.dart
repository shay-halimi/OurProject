library points_repository;

import 'models/models.dart';

abstract class PointsRepository {
  /// find near by Points for the giving Point
  Stream<List<Point>> near(Point point, {num radiusInKM = 3.14159265});

  /// subscribe to a point
  Stream<Point> point(String id);

  /// create a point
  Future<void> create(Point point);

  /// upload point
  Future<void> update(Point point);
}
