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
    return _collection.doc(point.id).set(point.toEntity().toDocument());
  }

  @override
  Stream<List<Point>> near(Point point, {num radiusInKM = 3.14159265}) {
    final center = _geo.point(
      latitude: point.location.latitude,
      longitude: point.location.longitude,
    );

    return _geo
        .collection(collectionRef: _collection)
        .within(
          center: center,
          radius: radiusInKM.toDouble(),
          field: 'location',
        )
        .map((List<DocumentSnapshot> snapshot) {
      return snapshot.map((DocumentSnapshot doc) {
        return Point.fromEntity(PointEntity.fromSnapshot(doc));
      }).toList();
    });
  }

  @override
  Stream<Point> point(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Point.fromEntity(PointEntity.fromSnapshot(snapshot));
      }

      return Point.empty;
    });
  }

  @override
  Future<void> update(Point point) {
    return _collection.doc(point.id).update(point.toEntity().toDocument());
  }
}
