import 'dart:async';

import 'package:accounts_repository/accounts_repository.dart';

abstract class AccountsRepository {
  Future<void> add(Account account);

  Future<void> delete(Account account);

  Stream<List<Account>> accounts();

  Future<void> update(Account account);
}
