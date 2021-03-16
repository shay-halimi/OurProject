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
  Stream<List<Point>> points() async* {}

  @override
  Stream<List<Point>> near({LatLng latLng, num radiusInKM = 3.14}) async* {
    final rand = Random();

    yield [];

    final list = [
      for (var i = 0; i <= 300; i++)
        Point.empty.copyWith(
            id: rand.nextInt(999999999).toString(),
            title: lipsum.createWord(numWords: 1 + rand.nextInt(5)),
            description: rand.nextBool()
                ? lipsum.createSentence()
                : lipsum.createParagraph(),
            latLng: LatLng(
              latitude: latLng.latitude +
                  ((rand.nextDouble() - rand.nextDouble()) *
                      (rand.nextBool() ? 9 : -9)),
              longitude: latLng.longitude +
                  ((rand.nextDouble() - rand.nextDouble()) *
                      (rand.nextBool() ? 9 : -9)),
            ),
            price: Money.empty.copyWith(amount: rand.nextDouble() * 1000),
            media: {
              'https://picsum.photos/seed/${lipsum.createWord()}/1280/720',
            },
            tags: {
              if (rand.nextBool()) 'צמחוני',
              if (rand.nextBool()) 'טבעוני',
              if (rand.nextBool()) 'ללא גלוטן',
            })
    ];

    yield list;
  }

  @override
  Future<void> delete(Point point) async {}

  @override
  Stream<List<Point>> byCookerId(String cookerId) async* {}
}
