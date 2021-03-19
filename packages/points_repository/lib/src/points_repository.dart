library points_repository;

import 'models/models.dart';

abstract class PointsRepository {
  Stream<List<Point>> near({LatLng latLng, num radiusInKM = 3.14});

  Future<void> create(Point point);

  Future<void> update(Point point);

  Future<void> delete(Point point);

  Stream<List<Point>> byCookerId(String cookerId);
}
