import 'package:cloud_firestore/cloud_firestore.dart';

class DistanceDocSnapshot {
  final DocumentSnapshot documentSnapshot;
  double distance;

  // ignore: sort_constructors_first
  DistanceDocSnapshot(this.documentSnapshot, this.distance);
}
