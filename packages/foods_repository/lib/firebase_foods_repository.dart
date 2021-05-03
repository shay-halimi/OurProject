import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'foods_repository.dart';
import 'src/entities/entities.dart';

class FirebaseFoodsRepository extends FoodsRepository {
  final _collection = FirebaseFirestore.instance.collection('points');
  final _geo = Geoflutterfire();

  @override
  Future<void> create(Food food) {
    return _collection.add(food
        .copyWith(
          createdAt: Time.now(),
          updatedAt: Time.now(),
        )
        .toEntity()
        .toDocument());
  }

  @override
  Future<void> update(Food food) {
    return _collection.doc(food.id).update(food
        .copyWith(
          updatedAt: Time.now(),
        )
        .toEntity()
        .toDocument());
  }

  @override
  Stream<List<Food>> near({LatLng latLng, num radiusInKM = 3.14}) {
    return _geo
        .collection(collectionRef: _collection)
        .within(
          center: _geo.point(
            latitude: latLng.latitude,
            longitude: latLng.longitude,
          ),
          radius: radiusInKM.toDouble(),
          field: 'latLng',
        )
        .map((snapshot) {
      return snapshot.map((doc) {
        return Food.fromEntity(FoodEntity.fromSnapshot(doc));
      }).toList();
    });
  }

  @override
  Future<void> delete(Food food) {
    return update(food.copyWith(
      deletedAt: Time.now(),
    ));
  }

  @override
  Future<void> restore(Food food) {
    return update(food.copyWith(
      deletedAt: Time.empty,
    ));
  }

  @override
  Stream<List<Food>> byRestaurantId(String restaurantId) {
    return _collection
        .where('cookId', isEqualTo: restaurantId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Food.fromEntity(FoodEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}
