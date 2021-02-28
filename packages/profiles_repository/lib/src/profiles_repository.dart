import 'dart:async';

import 'package:profiles_repository/profiles_repository.dart';

abstract class ProfilesRepository {
  Stream<Profile> profile(String id);

  Future<void> create(Profile profile);

  Future<void> update(Profile profile);
}
