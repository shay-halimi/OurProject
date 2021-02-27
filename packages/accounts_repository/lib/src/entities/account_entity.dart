import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AccountEntity extends Equatable {
  const AccountEntity({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.about,
    @required this.phoneNumber,
    @required this.available,
  });

  factory AccountEntity.fromJson(Map<String, Object> json) {
    return AccountEntity(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String,
      about: json['about'] as String,
      phoneNumber: json['phoneNumber'] as String,
      available: json['available'] as bool,
    );
  }

  factory AccountEntity.fromSnapshot(DocumentSnapshot snap) {
    return AccountEntity(
      id: snap.id,
      displayName: snap.data()['displayName'] as String,
      photoURL: snap.data()['photoURL'] as String,
      about: snap.data()['about'] as String,
      phoneNumber: snap.data()['phoneNumber'] as String,
      available: snap.data()['available'] as bool,
    );
  }

  final String id;
  final String displayName;
  final String photoURL;
  final String about;
  final String phoneNumber;
  final bool available;

  @override
  List<Object> get props =>
      [id, displayName, photoURL, about, phoneNumber, available];

  @override
  String toString() {
    return 'AccountEntity{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, about: $about, '
        'phoneNumber: $phoneNumber, available: $available}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoURL': photoURL,
      'about': about,
      'phoneNumber': phoneNumber,
      'available': available,
    };
  }

  Map<String, Object> toDocument() {
    return {
      'displayName': displayName,
      'photoURL': photoURL,
      'about': about,
      'phoneNumber': phoneNumber,
      'available': available,
    };
  }
}
