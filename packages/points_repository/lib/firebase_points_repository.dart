import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'points_repository.dart';
import 'src/entities/entities.dart';

class FirebasePointsRepository extends PointsRepository {
  final _collection = FirebaseFirestore.instance.collection('points');

  final _geo = Geoflutterfire();

  @override
  Stream<List<Point>> near(Point point) {
    const radiusInKM = 5.0;

    final center = _geo.point(
      latitude: point.latitude,
      longitude: point.longitude,
    );

    return _geo
        .collection(collectionRef: _collection)
        .within(center: center, radius: radiusInKM, field: 'geoPoint')
        .map((List<DocumentSnapshot> snapshot) {
      return snapshot.map((DocumentSnapshot doc) {
        return Point.fromEntity(PointEntity.fromSnapshot(doc));
      }).toList();
    });
  }

  @override
  Future<void> set(Point point) {
    return _collection.doc(point.id).set(point.toEntity().toDocument());
  }
}
