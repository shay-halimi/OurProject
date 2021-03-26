import 'dart:async';
import 'dart:math';

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
    final fake = _fake().toList();

    final list = [
      for (var i = 0; i <= 500; i++)
        fake[rand.nextInt(fake.length)].copyWith(
          id: rand.nextInt(999999999).toString(),
          latLng: LatLng(
            latitude: latLng.latitude +
                ((rand.nextDouble() - rand.nextDouble()) *
                    (rand.nextBool() ? 0.1 : -0.1)),
            longitude: latLng.longitude +
                ((rand.nextDouble() - rand.nextDouble()) *
                    (rand.nextBool() ? 0.1 : -0.1)),
          ),
          price: Money.empty.copyWith(
            amount: (19 + (rand.nextDouble() * 30)).floorToDouble(),
          ),
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
    final fake = _fake().toList();

    final streamController = StreamController<Set<Point>>()
      ..onListen = () {
        if (getCookerPoints(cookerId).isEmpty) {
          for (var i = 0; i <= rand.nextInt(3); i++)
            create(fake[rand.nextInt(fake.length)].copyWith(
              id: rand.nextInt(999999999).toString(),
              cookerId: cookerId,
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

  Set<Point> _fake() {
    return {
      Point.empty.copyWith(
        title: 'כדורי שוקולד',
        description: 'כדורי שוקולד טעימים טעימים עשויים עם המון אהבה ‏😊'
            '\n'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F6b81a970-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=413ca2ec-efee-4e8a-9bd3-c880e7ebf6c5'
        },
        tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
      ),
      Point.empty.copyWith(
        title: 'עוגת שוקולד מהממת',
        description: '',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F18710370-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=788a2147-9646-4a54-8d68-cbf46933faac'
        },
        tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
      ),
      Point.empty.copyWith(
        title: 'קאפקייק שחיטות',
        description: '',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F3ed31030-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=08ea9521-4b61-4207-8672-b9a52030331b'
        },
        tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
      ),
      Point.empty.copyWith(
        title: 'קאפקייק',
        description: '',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F5af75910-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=73e5d5d0-5ef1-45f8-a462-875589e2513f'
        },
        tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
      ),
      Point.empty.copyWith(
        title: 'פיצה ביתית מושלמת!🍕',
        description: '''פיצה טריה עשויה בעבודת יד יום יום מרכיבים טריים

משולש 20 ש''ח 
מגש 6 משולשים - 80 ש''ח 

הזמנות עד יום חמישי ב18:00
ניתן לפנות בוואצאפ או בטלפון ''',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F273316f0-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=b9213ba2-ffa8-41c4-9911-97f5069edf26'
        },
        tags: {'צמחוני'},
      ),
      Point.empty.copyWith(
        title: 'פרגיות בתנור',
        description: '',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F495a8740-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=e35aef68-385f-4557-ac19-1475d8141bcb'
        },
        tags: {'ללא גלוטן'},
      ),
      Point.empty.copyWith(
        title: 'קינוחים אישיים',
        description: 'קינוחים אישיים חמים היישר מהתנור עם המון אהבה ‏😊‎'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ ‏',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F51979920-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=cf8e2327-594b-4f68-830c-b4ce0778317c'
        },
      ),
      Point.empty.copyWith(
        title: 'כדורי שוקולד',
        description: 'כדורי שוקולד טעימים טעימים עם המון אהבה ‏😊'
            '\n'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F6b81a970-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=413ca2ec-efee-4e8a-9bd3-c880e7ebf6c5'
        },
        tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
      ),
      Point.empty.copyWith(
        title: 'קינוחים אישיים',
        description: 'קינוחים אישיים חמים היישר מהתנור עם המון אהבה ‏😊‎'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ ‏',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F51979920-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=cf8e2327-594b-4f68-830c-b4ce0778317c'
        },
      ),
    };
  }
}
