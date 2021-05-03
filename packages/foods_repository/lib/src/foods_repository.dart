library foods_repository;

import 'models/models.dart';

abstract class FoodsRepository {
  Stream<List<Food>> near({LatLng latLng, num radiusInKM = 3.14});

  Future<void> create(Food food);

  Future<void> update(Food food);

  Future<void> delete(Food food);

  Future<void> restore(Food food);

  Stream<List<Food>> byRestaurantId(String restaurantId);
}
