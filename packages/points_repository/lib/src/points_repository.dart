library points_repository;

import 'models/models.dart';

abstract class PointsRepository {
  Stream<List<Point>> near({
    double latitude,
    double longitude,
    num radiusInKM = 3.14,
  });

  Future<void> add(Point point);

  Future<void> update(Point point);

  Stream<List<Point>> points();

  Future<void> delete(Point point);
}
