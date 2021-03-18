import 'dart:async';
import 'dart:math';

import 'package:lipsum/lipsum.dart' as lipsum;
import 'package:points_repository/points_repository.dart';

import 'points_repository.dart';

class FakePointsRepository extends PointsRepository {
  @override
  Future<void> add(Point point) async {}

  @override
  Future<void> update(Point point) async {}

  @override
  Stream<List<Point>> points() async* {
    yield* near(latLng: LatLng.empty);
  }

  @override
  Stream<List<Point>> near({LatLng latLng, num radiusInKM = 3.14}) async* {
    await Future<void>.delayed(const Duration(seconds: 1));

    final rand = Random();

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
            'https://picsum.photos/seed/${0 + rand.nextInt(50)}/1280/720',
            'https://picsum.photos/seed/${0 + rand.nextInt(50)}/1280/720',
          },
          tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
        )
    ];

    yield list;
  }

  @override
  Future<void> delete(Point point) async {}

  @override
  Stream<List<Point>> byCookerId(String cookerId) async* {
    final rand = Random();

    yield await near(latLng: LatLng.empty).single.then((list) => list
        .take(0 + rand.nextInt(5))
        .map((point) => rand.nextBool()
            ? point
            : point.copyWith(
                latLng: LatLng.empty,
              ))
        .toList());
  }
}
