import 'dart:async';
import 'dart:math';

import 'package:lipsum/lipsum.dart' as lipsum;

import 'cooks_repository.dart';
import 'models/models.dart';

class FakeCooksRepository implements CooksRepository {
  final rand = Random();
  final Map<String, Cook> cooks = {};

  @override
  Stream<Cook> cook(String id) async* {
    if (!cooks.containsKey(id)) {
      cooks[id] = Cook(
        id: id,
        displayName: lipsum.createWord(numWords: 1 + rand.nextInt(3)),
        address: Address(
          name: lipsum.createWord(numWords: 1 + rand.nextInt(3)),
          latitude: 35,
          longitude: 17,
        ),
        phoneNumber: id,
        photoURL: 'https://i.pravatar.cc/300',
      );
    }

    yield* Stream<Cook>.periodic(
      const Duration(seconds: 1),
      (_) => cooks[id],
    );
  }

  @override
  Future<void> create(Cook cook) async {
    cooks.putIfAbsent(cook.id, () => cook);
  }

  @override
  Future<void> update(Cook cook) async {
    cooks[cook.id] = cook;
  }
}
