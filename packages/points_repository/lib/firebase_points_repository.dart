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
  Stream<List<Point>> nearby(Point point, {num radiusInKM = 3.14}) {
    final center = _geo.point(
      latitude: point.latitude,
      longitude: point.longitude,
    );

    return _geo
        .collection(collectionRef: _collection)
        .within(
          center: center,
          radius: radiusInKM.toDouble(),
          field: PointEntity.geoPointField,
        )
        .map((snapshot) {
      return snapshot.map((doc) {
        return Point.fromEntity(PointEntity.fromSnapshot(doc));
      }).toList();
    });
  }
}
