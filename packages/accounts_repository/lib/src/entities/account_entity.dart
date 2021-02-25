import 'package:accounts_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String displayName;
  final String photoUrl;
  final String about;
  final String phoneNumber;
  final Location location;
  final bool available;

  const AccountEntity({
    this.id,
    this.displayName,
    this.photoUrl,
    this.about,
    this.phoneNumber,
    this.location,
    this.available,
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'about': about,
      'phoneNumber': phoneNumber,
      'location': location.toJson(),
      'available': available,
    };
  }

  @override
  List<Object> get props => [
        id,
        displayName,
        photoUrl,
        about,
        phoneNumber,
        location,
    available,
      ];

  @override
  String toString() {
    return 'AccountEntity { id: $id, displayName: $displayName, photoUrl: $photoUrl, about: $about, phoneNumber: $phoneNumber, location: $location, available: $available}';
  }

  static AccountEntity fromJson(Map<String, Object> json) {
    return AccountEntity(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      about: json['about'] as String,
      phoneNumber: json['phoneNumber'] as String,
      location: Location.fromJson(json['location']),
      available: json['available'] as bool,
    );
  }

  static AccountEntity fromSnapshot(DocumentSnapshot snap) {
    return AccountEntity(
      id: snap.id,
      displayName: snap.data()['displayName'] as String,
      photoUrl: snap.data()['photoUrl'] as String,
      about: snap.data()['about'] as String,
      phoneNumber: snap.data()['phoneNumber'] as String,
      location: Location.fromJson(snap.data()['location']),
      available: snap.data()['available'] as bool,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'displayName': displayName,
      'photoUrl': photoUrl,
      'about': about,
      'phoneNumber': phoneNumber,
      'location': location.toJson(),
      'available': available,
    };
  }
}
