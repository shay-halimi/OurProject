import 'dart:async';

import 'models/models.dart';

abstract class RestaurantsRepository {
  Stream<Restaurant> restaurant(String id);

  Future<void> create(Restaurant restaurant);

  Future<void> update(Restaurant restaurant);
}
