import 'package:cloud_firestore/cloud_firestore.dart';

import 'entities/entities.dart';
import 'models/models.dart';
import 'profiles_repository.dart';

class FirebaseProfilesRepository implements ProfilesRepository {
  FirebaseProfilesRepository();

  final _collection = FirebaseFirestore.instance.collection('profiles');

  @override
  Stream<Profile> profile(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Profile.fromEntity(ProfileEntity.fromSnapshot(snapshot));
      }

      return Profile.empty;
    });
  }

  @override
  Future<void> create(Profile profile) {
    return _collection.doc(profile.id).set(profile.toEntity().toDocument());
  }

  @override
  Future<void> update(Profile profile) {
    return _collection.doc(profile.id).update(profile.toEntity().toDocument());
  }
}
