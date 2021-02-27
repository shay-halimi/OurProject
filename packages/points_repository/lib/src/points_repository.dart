library points_repository;

import 'models/point.dart';

abstract class PointsRepository {
  Stream<List<Point>> near(Point point);

  Future<void> set(Point point);
}
