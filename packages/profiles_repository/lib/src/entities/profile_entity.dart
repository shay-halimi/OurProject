import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.about,
    @required this.phoneNumber,
  });

  factory ProfileEntity.fromJson(Map<String, Object> json) {
    return ProfileEntity(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String,
      about: json['about'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  factory ProfileEntity.fromSnapshot(DocumentSnapshot snap) {
    return ProfileEntity(
      id: snap.id,
      displayName: snap.data()['displayName'] as String,
      photoURL: snap.data()['photoURL'] as String,
      about: snap.data()['about'] as String,
      phoneNumber: snap.data()['phoneNumber'] as String,
    );
  }

  final String id;
  final String displayName;
  final String photoURL;
  final String about;
  final String phoneNumber;

  @override
  List<Object> get props => [id, displayName, photoURL, about, phoneNumber];

  @override
  String toString() {
    return 'ProfileEntity{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, about: $about, phoneNumber: $phoneNumber}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoURL': photoURL,
      'about': about,
      'phoneNumber': phoneNumber,
    };
  }

  Map<String, Object> toDocument() {
    return {
      'displayName': displayName,
      'photoURL': photoURL,
      'about': about,
      'phoneNumber': phoneNumber,
    };
  }
}
