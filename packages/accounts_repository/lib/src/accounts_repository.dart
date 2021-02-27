import 'dart:async';

import 'package:accounts_repository/accounts_repository.dart';

abstract class AccountsRepository {
  Stream<Account> account(String id);

  Stream<List<Account>> accounts();

  Future<void> set(Account account);

  Future<void> add(Account account);

  Future<void> delete(Account account);

  Future<void> update(Account account);
}
