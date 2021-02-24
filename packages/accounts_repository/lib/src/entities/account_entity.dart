import 'package:accounts_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String photoUrl;
  final String about;
  final String phoneNumber;
  final Location location;
  final int status;

  const AccountEntity({
    this.id,
    this.userId,
    this.displayName,
    this.photoUrl,
    this.about,
    this.phoneNumber,
    this.location,
    this.status,
  });

  Map<String, Object> toJson() {
    return {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'about': about,
      'phoneNumber': phoneNumber,
      'location': location.toJson(),
      'status': status,
    };
  }

  @override
  List<Object> get props => [
        id,
        userId,
        displayName,
        photoUrl,
        about,
        phoneNumber,
        location,
        status,
      ];

  @override
  String toString() {
    return 'AccountEntity { id: $id, userId: $userId, displayName: $displayName, photoUrl: $photoUrl, about: $about, phoneNumber: $phoneNumber, location: $location, status: $status}';
  }

  static AccountEntity fromJson(Map<String, Object> json) {
    return AccountEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      about: json['about'] as String,
      phoneNumber: json['phoneNumber'] as String,
      location: Location.fromJson(json['location']),
      status: json['status'] as int,
    );
  }

  static AccountEntity fromSnapshot(DocumentSnapshot snap) {
    return AccountEntity(
      id: snap.id,
      userId: snap.data()['userId'] as String,
      displayName: snap.data()['displayName'] as String,
      photoUrl: snap.data()['photoUrl'] as String,
      about: snap.data()['about'] as String,
      phoneNumber: snap.data()['phoneNumber'] as String,
      location: Location.fromJson(snap.data()['location']),
      status: snap.data()['status'] as int,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'userId': userId,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'about': about,
      'phoneNumber': phoneNumber,
      'location': location.toJson(),
      'status': status,
    };
  }
}
