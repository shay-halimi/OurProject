import 'dart:async';
import 'dart:math';

import 'package:lipsum/lipsum.dart' as lipsum;

import 'cookers_repository.dart';
import 'models/models.dart';

class FakeCookersRepository implements CookersRepository {
  final rand = Random();
  final Map<String, Set<StreamController<Cooker>>> _streamControllers = {};

  @override
  Stream<Cooker> cooker(String id) {
    if (!_streamControllers.containsKey(id)) {
      _streamControllers[id] = {};
    }

    final streamController = StreamController<Cooker>()
      ..onListen = () {
        create(Cooker(
          id: id,
          displayName: lipsum.createWord(numWords: 1 + rand.nextInt(3)),
          address: Address(
            name: lipsum.createWord(numWords: 1 + rand.nextInt(3)),
            latitude: ((rand.nextDouble() - rand.nextDouble()) *
                (rand.nextBool() ? 1 : -1)),
            longitude: ((rand.nextDouble() - rand.nextDouble()) *
                (rand.nextBool() ? 1 : -1)),
          ),
          phoneNumber: id,
          photoURL: 'https://i.pravatar.cc/300#${rand.nextInt(9999999)}',
        ));
      };

    _streamControllers[id].add(streamController);

    return streamController.stream;
  }

  @override
  Future<void> create(Cooker cooker) async {
    update(cooker);
  }

  @override
  Future<void> update(Cooker cooker) async {
    if (!_streamControllers.containsKey(cooker.id)) return;

    _streamControllers[cooker.id].forEach((streamController) {
      streamController.add(cooker);
    });
  }
}
