import 'package:accounts_repository/src/models/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String profilePhoto;
  final String about;
  final String phoneNumber;
  final Location location;
  final bool open;

  const AccountEntity({
    this.id,
    this.userId,
    this.displayName,
    this.profilePhoto,
    this.about,
    this.phoneNumber,
    this.location,
    this.open,
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      'profilePhoto': profilePhoto,
      'about': about,
      'phoneNumber': phoneNumber,
      'location': location.toJson(),
      'open': open,
    };
  }

  @override
  List<Object> get props => [
        id,
        userId,
        displayName,
        profilePhoto,
        about,
        phoneNumber,
        location,
        open,
      ];

  @override
  String toString() {
    return 'AccountEntity { id: $id, userId: $userId, displayName: $displayName, profilePhoto: $profilePhoto, about: $about, phoneNumber: $phoneNumber, location: $location, open: $open}';
  }

  static AccountEntity fromJson(Map<String, Object> json) {
    return AccountEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      profilePhoto: json['profilePhoto'] as String,
      about: json['about'] as String,
      phoneNumber: json['phoneNumber'] as String,
      location: Location.fromJson(json['location']),
      open: json['open'] as bool,
    );
  }

  static AccountEntity fromSnapshot(DocumentSnapshot snap) {
    return AccountEntity(
      id: snap.id,
      userId: snap.data()['userId'] as String,
      displayName: snap.data()['displayName'] as String,
      profilePhoto: snap.data()['profilePhoto'] as String,
      about: snap.data()['about'] as String,
      phoneNumber: snap.data()['phoneNumber'] as String,
      location: Location.fromJson(snap.data()['location']),
      open: snap.data()['open'] as bool,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'userId': userId,
      'displayName': displayName,
      'profilePhoto': profilePhoto,
      'about': about,
      'phoneNumber': phoneNumber,
      'location': location.toJson(),
      'open': open,
    };
  }
}