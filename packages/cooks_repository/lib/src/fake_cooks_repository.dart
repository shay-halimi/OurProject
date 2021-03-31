import 'dart:async';
import 'dart:math';

import 'cooks_repository.dart';
import 'models/models.dart';

class FakeCooksRepository implements CooksRepository {
  final rand = Random();
  final Map<String, Cook> cooks = {};

  @override
  Stream<Cook> cook(String id) async* {
    if (!cooks.containsKey(id)) {
      final hebrew = rand.nextBool();
      cooks[id] = Cook(
        id: id,
        displayName: hebrew ? 'Noa Cohen' : 'נעה כהן',
        address: Address(
          name: hebrew ? 'Israel' : 'ישראל',
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
