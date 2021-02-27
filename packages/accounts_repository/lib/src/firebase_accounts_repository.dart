import 'package:cloud_firestore/cloud_firestore.dart';

import 'accounts_repository.dart';
import 'entities/entities.dart';
import 'models/models.dart';

class FirebaseAccountsRepository implements AccountsRepository {
  FirebaseAccountsRepository();

  final _collection = FirebaseFirestore.instance.collection('accounts');

  @override
  Stream<Account> account(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Account.fromEntity(AccountEntity.fromSnapshot(snapshot));
      }

      return Account.empty;
    });
  }

  @override
  Stream<List<Account>> accounts() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Account.fromEntity(AccountEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> set(Account account) {
    return _collection.doc(account.id).set(account.toEntity().toDocument());
  }

  @override
  Future<void> add(Account account) {
    return _collection.add(account.toEntity().toDocument());
  }

  @override
  Future<void> delete(Account account) {
    return _collection.doc(account.id).delete();
  }

  @override
  Future<void> update(Account account) {
    return _collection.doc(account.id).update(account.toEntity().toDocument());
  }
}
