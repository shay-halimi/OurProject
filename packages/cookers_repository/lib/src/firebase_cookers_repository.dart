import 'package:cloud_firestore/cloud_firestore.dart';

import 'cookers_repository.dart';
import 'entities/entities.dart';
import 'models/models.dart';

class FirebaseCookersRepository implements CookersRepository {
  FirebaseCookersRepository();

  final _collection = FirebaseFirestore.instance.collection('cookers');

  @override
  Stream<Cooker> cooker(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Cooker.fromEntity(CookerEntity.fromSnapshot(snapshot));
      }

      return Cooker.empty;
    });
  }

  @override
  Future<void> create(Cooker cooker) {
    return _collection.doc(cooker.id).set(cooker.toEntity().toDocument());
  }

  @override
  Future<void> update(Cooker cooker) {
    return _collection.doc(cooker.id).update(cooker.toEntity().toDocument());
  }
}
