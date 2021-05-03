import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities/entities.dart';
import 'models/models.dart';
import 'restaurants_repository.dart';

class FirebaseRestaurantsRepository implements RestaurantsRepository {
  FirebaseRestaurantsRepository();

  final _collection = FirebaseFirestore.instance.collection('restaurants');

  @override
  Stream<Restaurant> restaurant(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Restaurant.fromEntity(RestaurantEntity.fromSnapshot(snapshot));
      }

      return Restaurant.empty;
    });
  }

  @override
  Future<void> create(Restaurant restaurant) {
    return _collection
        .doc(restaurant.id)
        .set(restaurant.toEntity().toDocument());
  }

  @override
  Future<void> update(Restaurant restaurant) {
    return _collection
        .doc(restaurant.id)
        .update(restaurant.toEntity().toDocument());
  }
}
