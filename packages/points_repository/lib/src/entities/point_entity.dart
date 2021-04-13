import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';

import '../models/models.dart';

class PointEntity extends Equatable {
  const PointEntity({
    @required this.id,
    @required this.cookId,
    @required this.latLng,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.media,
    @required this.tags,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.deletedAt,
  });

  factory PointEntity.fromSnapshot(DocumentSnapshot snap) {
    final geoPoint = snap.data()['latLng']['geopoint'] as GeoPoint;

    return PointEntity(
      id: snap.id,
      cookId: snap.data()['cookId'] as String,
      latLng: LatLng(
        latitude: geoPoint.latitude,
        longitude: geoPoint.longitude,
      ),
      title: snap.data()['title'] as String,
      description: snap.data()['description'] as String,
      price: Money.fromJson(snap.data()['price'] as Map<String, Object>),
      media: (snap.data()['media'] as List<Object>).toSet().cast<String>(),
      tags: (snap.data()['tags'] as List<Object>).toSet().cast<String>(),
      createdAt: Time.fromJson(snap.data()['createdAt'] as Map<String, Object>),
      updatedAt: Time.fromJson(snap.data()['updatedAt'] as Map<String, Object>),
      deletedAt: Time.fromJson(snap.data()['deletedAt'] as Map<String, Object>),
    );
  }

  final String id;
  final String cookId;
  final LatLng latLng;
  final String title;
  final String description;
  final Money price;
  final Set<String> media;
  final Set<String> tags;
  final Time createdAt;
  final Time updatedAt;
  final Time deletedAt;

  @override
  List<Object> get props => [
        id,
        cookId,
        latLng,
        title,
        description,
        price,
        media,
        tags,
        createdAt,
        updatedAt,
        deletedAt,
      ];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'cookId': cookId,
      'latLng': latLng.toJson(),
      'title': title,
      'description': description,
      'price': price.toJson(),
      'media': media,
      'tags': tags,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'deletedAt': deletedAt.toJson(),
    };
  }

  Map<String, Object> toDocument() {
    final geo = GeoFirePoint(latLng.latitude, latLng.longitude);

    /// we can filter firebase only by one field
    /// this is a workaround to ignore soft-deleted points for geo queries.
    final geoHash = deletedAt.isEmpty ? geo.hash : '';

    return {
      'cookId': cookId,
      'latLng': {
        'geopoint': geo.geoPoint,
        'geohash': geoHash,
      },
      'title': title,
      'description': description,
      'price': price.toJson(),
      'media': media.toList(),
      'tags': tags.toList(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'deletedAt': deletedAt.toJson(),
    };
  }
}
