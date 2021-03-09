import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CookerEntity extends Equatable {
  const CookerEntity({
    @required this.id,
    @required this.displayName,
    @required this.photoURL,
    @required this.phoneNumber,
  });

  factory CookerEntity.fromJson(Map<String, Object> json) {
    return CookerEntity(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  factory CookerEntity.fromSnapshot(DocumentSnapshot snap) {
    return CookerEntity(
      id: snap.id,
      displayName: snap.data()['displayName'] as String,
      photoURL: snap.data()['photoURL'] as String,
      phoneNumber: snap.data()['phoneNumber'] as String,
    );
  }

  final String id;
  final String displayName;
  final String photoURL;
  final String phoneNumber;

  @override
  List<Object> get props => [id, displayName, photoURL, phoneNumber];

  @override
  String toString() {
    return 'CookerEntity{id: $id, displayName: $displayName, '
        'photoURL: $photoURL, phoneNumber: $phoneNumber}';
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
    };
  }

  Map<String, Object> toDocument() {
    return {
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
    };
  }
}
