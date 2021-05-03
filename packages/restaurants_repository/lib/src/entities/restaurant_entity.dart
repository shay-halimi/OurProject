import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/models.dart';

class RestaurantEntity extends Equatable {
  const RestaurantEntity({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.phoneNumber,
    @required this.about,
    @required this.address,
  });

  factory RestaurantEntity.fromJson(Map<String, Object> json) {
    return RestaurantEntity(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String,
      phoneNumber: json['phoneNumber'] as String,
      about: json['json'] as String,
      address: Address.fromJson(json['address'] as Map<String, Object>),
    );
  }

  factory RestaurantEntity.fromSnapshot(DocumentSnapshot snap) {
    return RestaurantEntity(
      id: snap.id,
      displayName: snap.data()['displayName'] as String,
      photoURL: snap.data()['photoURL'] as String,
      phoneNumber: snap.data()['phoneNumber'] as String,
      about: (snap.data()['about'] ?? '') as String,
      address: Address.fromJson(snap.data()['address'] as Map<String, Object>),
    );
  }

  final String id;
  final String displayName;
  final String photoURL;
  final String phoneNumber;
  final String about;
  final Address address;

  @override
  List<Object> get props => [
        id,
        displayName,
        photoURL,
        phoneNumber,
        about,
        address,
      ];

  @override
  String toString() {
    return '$RestaurantEntity{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, phoneNumber: $phoneNumber, about: $about, '
        'address: $address}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'about': about,
      'address': address.toJson(),
    };
  }

  Map<String, Object> toDocument() {
    return {
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'about': about,
      'address': address.toJson(),
    };
  }
}
