import 'dart:math';

import 'package:lipsum/lipsum.dart' as lipsum;

import 'cookers_repository.dart';
import 'models/models.dart';

class FakeCookersRepository implements CookersRepository {
  @override
  Stream<Cooker> cooker(String id) async* {
    await Future<void>.delayed(const Duration(seconds: 1));

    final rand = Random();

    yield Cooker(
      id: id,
      displayName: lipsum.createWord(numWords: 1 + rand.nextInt(3)),
      address: Address(
          name: lipsum.createWord(numWords: 1 + rand.nextInt(3)),
          latitude: 0.0,
          longitude: 0.0),
      phoneNumber: '+97255' + (1000000 + rand.nextInt(9999999)).toString(),
      photoURL: 'https://i.pravatar.cc/300',
    );
  }

  @override
  Future<void> create(Cooker cooker) async {}

  @override
  Future<void> update(Cooker cooker) async {}
}
