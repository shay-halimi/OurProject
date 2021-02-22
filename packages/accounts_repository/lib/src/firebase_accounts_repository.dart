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
  Future<Account> findByUserId(String userId) {
    return collection.where('userId', isEqualTo: userId).get().then((value) {
      if (value.docs.isEmpty) {
        return Account.empty;
      }

      return Account.fromEntity(
        AccountEntity.fromSnapshot(value.docs.first),
      );
    });
  }
}
