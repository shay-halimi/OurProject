import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';

import '../models/models.dart';

class PointEntity extends Equatable {
  const PointEntity({
    @required this.id,
    @required this.cookerId,
    @required this.latitude,
    @required this.longitude,
    @required this.relevant,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.media,
    @required this.tags,
  });

  factory PointEntity.fromSnapshot(DocumentSnapshot snap) {
    final geoPoint = snap.data()['location']['geopoint'] as GeoPoint;

    return PointEntity(
      id: snap.id,
      cookerId: snap.data()['cookerId'] as String,
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
      relevant: snap.data()['relevant'] as bool,
      title: snap.data()['title'] as String,
      description: snap.data()['description'] as String,
      price: Money.fromJson(snap.data()['price'] as Map<String, Object>),
      media: (snap.data()['media'] as List<Object>).toSet().cast<String>(),
      tags: (snap.data()['tags'] as List<Object>).toSet().cast<String>(),
    );
  }

  final String id;
  final String cookerId;
  final double latitude;
  final double longitude;
  final bool relevant;
  final String title;
  final String description;
  final Money price;
  final Set<String> media;
  final Set<String> tags;

  @override
  List<Object> get props => [
        id,
        cookerId,
        latitude,
        longitude,
        relevant,
        title,
        description,
        price,
        media,
        tags,
      ];

  Map<String, Object> toJson() {
    return {
      'id': id,
      'cookerId': cookerId,
      'latitude': latitude,
      'longitude': longitude,
      'relevant': relevant,
      'title': title,
      'description': description,
      'price': price.toJson(),
      'media': media,
      'tags': tags,
    };
  }

  Map<String, Object> toDocument() {
    final location = GeoFirePoint(
      latitude,
      longitude,
    ).data as Map<String, Object>;

    return {
      'cookerId': cookerId,
      'location': location,
      'relevant': relevant,
      'title': title,
      'description': description,
      'price': price.toJson(),
      'media': media.toList(),
      'tags': tags.toList(),
    };
  }
}
