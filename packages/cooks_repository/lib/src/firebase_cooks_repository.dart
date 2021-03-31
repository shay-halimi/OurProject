import 'package:cloud_firestore/cloud_firestore.dart';

import 'cooks_repository.dart';
import 'entities/entities.dart';
import 'models/models.dart';

class FirebaseCooksRepository implements CooksRepository {
  FirebaseCooksRepository();

  final _collection = FirebaseFirestore.instance.collection('cookers');

  @override
  Stream<Cook> cook(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Cook.fromEntity(CookEntity.fromSnapshot(snapshot));
      }

      return Cook.empty;
    });
  }

  @override
  Future<void> create(Cook cook) {
    return _collection.doc(cook.id).set(cook.toEntity().toDocument());
  }

  @override
  Future<void> update(Cook cook) {
    return _collection.doc(cook.id).update(cook.toEntity().toDocument());
  }
}
