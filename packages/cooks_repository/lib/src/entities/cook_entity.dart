import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../models/models.dart';

class CookEntity extends Equatable {
  const CookEntity({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.phoneNumber,
    @required this.address,
  });

  factory CookEntity.fromJson(Map<String, Object> json) {
    return CookEntity(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: Address.fromJson(json['address'] as Map<String, Object>),
    );
  }

  factory CookEntity.fromSnapshot(DocumentSnapshot snap) {
    return CookEntity(
      id: snap.id,
      displayName: snap.data()['displayName'] as String,
      photoURL: snap.data()['photoURL'] as String,
      phoneNumber: snap.data()['phoneNumber'] as String,
      address: Address.fromJson(snap.data()['address'] as Map<String, Object>),
    );
  }

  final String id;
  final String displayName;
  final String photoURL;
  final String phoneNumber;
  final Address address;

  @override
  List<Object> get props => [id, displayName, photoURL, phoneNumber, address];

  @override
  String toString() {
    return 'CookEntity{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, phoneNumber: $phoneNumber, address: $address}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'address': address.toJson(),
    };
  }

  Map<String, Object> toDocument() {
    return {
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
      'address': address.toJson(),
    };
  }
}
