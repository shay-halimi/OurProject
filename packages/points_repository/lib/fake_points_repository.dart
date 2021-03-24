import 'dart:async';
import 'dart:math';

import 'package:lipsum/lipsum.dart' as lipsum;

import 'points_repository.dart';

class FakePointsRepository extends PointsRepository {
  final Map<String, Set<StreamController<Set<Point>>>>
      _cookerStreamControllers = {};

  final Map<String, Set<Point>> _cookerPoints = {};

  final rand = Random();

  @override
  Future<void> create(Point point) async {
    return update(point);
  }

  Set<Point> getCookerPoints(String cookerId) {
    if (!_cookerPoints.containsKey(cookerId)) {
      _cookerPoints[cookerId] = {};
    }
    return _cookerPoints[cookerId];
  }

  Set<StreamController<Set<Point>>> getCookerStreamControllers(
      String cookerId) {
    if (!_cookerStreamControllers.containsKey(cookerId)) {
      _cookerStreamControllers[cookerId] = {};
    }
    return _cookerStreamControllers[cookerId];
  }

  @override
  Future<void> update(Point point) async {
    final points = getCookerPoints(point.cookerId)
      ..removeWhere((other) => other.id == point.id)
      ..add(point);

    for (var streamController in getCookerStreamControllers(point.cookerId)) {
      streamController.add(points);
    }
  }

  @override
  Stream<List<Point>> near({LatLng latLng, num radiusInKM = 3.14}) async* {
    final list = [
      for (var i = 0; i <= 500; i++)
        Point.empty.copyWith(
          id: rand.nextInt(999999999).toString(),
          title: lipsum.createWord(numWords: 1 + rand.nextInt(6)),
          description:
              lipsum.createSentence(numSentences: 1 + rand.nextInt(20)),
          latLng: LatLng(
            latitude: latLng.latitude +
                ((rand.nextDouble() - rand.nextDouble()) *
                    (rand.nextBool() ? 1 : -1)),
            longitude: latLng.longitude +
                ((rand.nextDouble() - rand.nextDouble()) *
                    (rand.nextBool() ? 1 : -1)),
          ),
          price: Money.empty.copyWith(amount: 10 + (rand.nextDouble() * 200)),
          media: {
            'https://picsum.photos/seed/${0 + rand.nextInt(50)}/1280/720',
          },
          tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
        )
    ];

    yield list;
  }

  @override
  Future<void> delete(Point point) async {
    final points = getCookerPoints(point.cookerId)..remove(point);

    for (var streamController in getCookerStreamControllers(point.cookerId)) {
      streamController.add(points);
    }
  }

  @override
  Stream<List<Point>> byCookerId(String cookerId) {
    final streamController = StreamController<Set<Point>>()
      ..onListen = () {
        if (getCookerPoints(cookerId).isEmpty) {
          for (var i = 0; i <= rand.nextInt(3); i++)
            create(Point.empty.copyWith(
              id: rand.nextInt(999999999).toString(),
              cookerId: cookerId,
              title: lipsum.createWord(numWords: 1 + rand.nextInt(6)),
              description:
                  lipsum.createSentence(numSentences: 1 + rand.nextInt(10)),
              latLng: rand.nextBool()
                  ? LatLng.empty
                  : LatLng(
                      latitude: ((rand.nextDouble() - rand.nextDouble()) *
                          (rand.nextBool() ? 1 : -1)),
                      longitude: ((rand.nextDouble() - rand.nextDouble()) *
                          (rand.nextBool() ? 1 : -1)),
                    ),
              price:
                  Money.empty.copyWith(amount: 10 + (rand.nextDouble() * 200)),
              media: {
                'https://picsum.photos/seed/${0 + rand.nextInt(50)}/1280/720',
              },
              tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
            ));
        } else {
          for (var point in getCookerPoints(cookerId)) {
            update(point);
          }
        }
      };

    getCookerStreamControllers(cookerId).add(streamController);

    return streamController.stream.map((set) => set.toList());
  }
}
