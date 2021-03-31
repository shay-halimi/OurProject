import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'points_repository.dart';
import 'src/entities/entities.dart';

class FirebasePointsRepository extends PointsRepository {
  final _collection = FirebaseFirestore.instance.collection('points');
  final _geo = Geoflutterfire();

  @override
  Future<void> create(Point point) {
    return _collection.add(point.toEntity().toDocument());
  }

  @override
  Future<void> update(Point point) {
    return _collection.doc(point.id).update(point.toEntity().toDocument());
  }

  @override
  Stream<List<Point>> near({LatLng latLng, num radiusInKM = 3.14}) {
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
        return Point.fromEntity(PointEntity.fromSnapshot(doc));
      }).toList();
    });
  }

  @override
  Future<void> delete(Point point) {
    return _collection.doc(point.id).delete();
  }

  @override
  Stream<List<Point>> byCookId(String cookId) {
    return _collection
        .where('cookId', isEqualTo: cookId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Point.fromEntity(PointEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}
