import 'package:cloud_firestore/cloud_firestore.dart';

import 'accounts_repository.dart';
import 'entities/entities.dart';
import 'models/models.dart';

class FirebaseAccountsRepository implements AccountsRepository {
  final collection = FirebaseFirestore.instance.collection('accounts');

  @override
  Stream<List<Account>> accounts() {
    return collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Account.fromEntity(AccountEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> add(Account account) {
    return collection.add(account.toEntity().toDocument());
  }

  @override
  Future<void> delete(Account account) {
    return collection.doc(account.id).delete();
  }

  @override
  Future<void> update(Account account) {
    return collection.doc(account.id).update(account.toEntity().toDocument());
  }

  @override
  Stream<List<Account>> findByPhoneNumber(String phoneNumber) {
    return collection
        .where('phoneNumber', isEqualTo: phoneNumber)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => Account.fromEntity(AccountEntity.fromSnapshot(doc)))
            .toList();
      }

      add(Account.empty.copyWith(phoneNumber: phoneNumber));

      return [];
    });
  }
}
