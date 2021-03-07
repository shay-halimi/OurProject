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
  Future<void> add(Point point) {
    return _collection.add(point.toEntity().toDocument());
  }

  @override
  Future<void> update(Point point) {
    return _collection.doc(point.id).update(point.toEntity().toDocument());
  }

  @override
  Stream<List<Point>> points() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Point.fromEntity(PointEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Stream<List<Point>> near({
    double latitude,
    double longitude,
    num radiusInKM = 3.14,
  }) {
    assert(latitude != null);
    assert(longitude != null);
    assert(radiusInKM != null && radiusInKM > 0);

    final center = _geo.point(
      latitude: latitude,
      longitude: longitude,
    );

    return _geo
        .collection(collectionRef: _collection)
        .within(
          center: center,
          radius: radiusInKM.toDouble(),
          field: 'location',
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
}
