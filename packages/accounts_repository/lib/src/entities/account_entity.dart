import 'package:accounts_repository/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';

class AccountEntity extends Equatable {
  final String id;
  final String uid;
  final String displayName;
  final String photoURL;
  final String about;
  final String phoneNumber;
  final Location location;
  final bool available;

  const AccountEntity({
    @required this.id,
    @required this.uid,
    @required this.displayName,
    @required this.photoURL,
    @required this.about,
    @required this.phoneNumber,
    @required this.location,
    @required this.available,
  });

  @override
  List<Object> get props => [
        id,
        uid,
        displayName,
        photoURL,
        about,
        phoneNumber,
        location,
        available,
      ];

  @override
  String toString() {
    return 'AccountEntity{id: $id, uid: $uid, displayName: $displayName, photoURL: $photoURL, about: $about, phoneNumber: $phoneNumber, location: $location, available: $available}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'uid': uid,
      'displayName': displayName,
      'photoURL': photoURL,
      'about': about,
      'phoneNumber': phoneNumber,
      'location': location.toJson(),
      'available': available,
    };
  }

  Map<String, Object> toDocument() {
    return {
      'uid': uid,
      'displayName': displayName,
      'photoURL': photoURL,
      'about': about,
      'phoneNumber': phoneNumber,
      'location': GeoFirePoint(location.latitude, location.longitude).data,
      'available': available,
    };
  }

  static AccountEntity fromJson(Map<String, Object> json) {
    return AccountEntity(
      id: json['id'] as String,
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String,
      about: json['about'] as String,
      phoneNumber: json['phoneNumber'] as String,
      location: Location.fromJson(json['location'] as Map<String, Object>),
      available: json['available'] as bool,
    );
  }

  static AccountEntity fromSnapshot(DocumentSnapshot snap) {
    GeoPoint point = snap.data()['location']['geopoint'];

    return AccountEntity(
      id: snap.id,
      uid: snap.data()['uid'] as String,
      displayName: snap.data()['displayName'] as String,
      photoURL: snap.data()['photoURL'] as String,
      about: snap.data()['about'] as String,
      phoneNumber: snap.data()['phoneNumber'] as String,
      location: Location(point.latitude, point.longitude),
      available: snap.data()['available'] as bool,
    );
  }
}
