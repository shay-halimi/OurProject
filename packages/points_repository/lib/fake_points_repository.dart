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
            title: lipsum.createWord(numWords: 1 + rand.nextInt(20)),
            description: rand.nextBool()
                ? lipsum.createSentence(numSentences: 1 + rand.nextInt(20))
                : lipsum.createParagraph(numParagraphs: 1 + rand.nextInt(20)),
            latLng: rand.nextBool()
                ? LatLng.empty
                : LatLng(
                    latitude: latLng.latitude +
                        ((rand.nextDouble() - rand.nextDouble()) *
                            (rand.nextBool() ? 9 : -9)),
                    longitude: latLng.longitude +
                        ((rand.nextDouble() - rand.nextDouble()) *
                            (rand.nextBool() ? 9 : -9)),
                  ),
            price: Money.empty.copyWith(amount: rand.nextDouble() * 100000),
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
  Stream<List<Point>> byCookerId(String cookerId) async* {
    yield await near(latLng: LatLng.empty)
        .single
        .then((value) => value.take(5).toList());
  }
}
