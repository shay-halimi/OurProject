library points_repository;

import 'models/models.dart';

abstract class PointsRepository {
  /// find near by points for the giving point
  Stream<List<Point>> nearby(Point point, {num radiusInKM = 3.14});

  /// create a point
  Future<void> create(Point point);

  /// update a point
  Future<void> update(Point point);
}
