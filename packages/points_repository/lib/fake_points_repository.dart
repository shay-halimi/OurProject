import 'dart:async';
import 'dart:math';

import 'points_repository.dart';

class FakePointsRepository extends PointsRepository {
  final _listeners = <MultiStreamController<List<Point>>>[];

  final List<Point> _points = [];

  final rand = Random();

  @override
  Future<void> create(Point point) async {
    _points.add(point);
    emit();
  }

  @override
  Future<void> update(Point point) async {
    return Future.wait([
      delete(point),
      create(point),
    ]);
  }

  @override
  Future<void> delete(Point point) async {
    _points.removeWhere((_point) => _point.id == point.id);
    emit();
  }

  void emit() {
    for (var listener in _listeners) listener.add(_points);
  }

  @override
  Stream<List<Point>> near({LatLng latLng, num radiusInKM = 3.14}) async* {
    await Future<void>.delayed(const Duration(seconds: 1));

    for (var i = 0; i <= 30; i++) {
      await create(_randPoint.copyWith(
        latLng: LatLng(
          latitude: latLng.latitude + _randKm,
          longitude: latLng.longitude + _randKm,
        ),
      ));
    }

    yield* stream();
  }

  @override
  Stream<List<Point>> byCookId(String cookId) async* {
    await Future<void>.delayed(const Duration(seconds: 1));

    if (_points.where((point) => point.cookId == cookId).isEmpty) {
      for (var i = 0; i <= 3; i++) {
        await create(_randPoint.copyWith(
          cookId: cookId,
        ));
      }
    }

    yield* stream().map((points) {
      return points.where((point) => point.cookId == cookId).toList();
    });
  }

  Stream<List<Point>> stream() {
    return Stream.multi((controller) {
      _listeners.add(controller);

      controller.onCancel = () {
        _listeners.remove(controller);
      };

      emit();
    });
  }

  Point get _randPoint {
    final fake = [
      Point.empty.copyWith(
        title: 'כדורי שוקולד',
        description: 'כדורי שוקולד טעימים טעימים עשויים עם המון אהבה ‏😊'
            '\n'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F6b81a970-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=413ca2ec-efee-4e8a-9bd3-c880e7ebf6c5'
        },
      ),
      Point.empty.copyWith(
        title: 'ג׳חנון',
        description: '''עכשיו זה הזמן !!!
🔷ג’חנון קפוא לאפיה ביתית 🔷
ארוז ומוכן להיכנס לתנור ואפילו אין צורך בסיר
והשבת..
כמו בכל שבת גם השבת ⭐ הג׳חנון מככב
🔷משלוח רק 5 ₪( מינימום למשלוח 2 מנות)
🔷ג’חנון +ביצה + רסק + סחוג = 20 ₪
🔷קובנה - בגדלים שונים 30 ₪ / 40 ₪ ( בהזמנה מראש בלבד )
🔷אריזה של 5 ג׳חנונים קפואים לאפיה ביתית ב50 ₪
🔷סחוג טרי 15 ₪
ממליצה מאוד להזמין מראש 
לפרטים נוספים והזמנות התקשרו ☎️
תמר 👍🏼🙏
 ''',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F273316f0-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=b9213ba2-ffa8-41c4-9911-97f5069edf26'
        },
      ),
      Point.empty.copyWith(
        title: "ג'חנון אסלי",
        description: 'קר בחוץ ואין לכם כוח לצאת? התקשרו אלינו עכשיו '
            'ואנחנו נגיע עד אליכם עם גחנון אסלי, חם וטעים בטירוף',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F66b17410-921b-11eb-b9a6-6bc3d7477c4a?alt=media&token=1ea07f6e-6b6c-4c2a-8ba7-14d1cf2b564c'
        },
      ),
      Point.empty.copyWith(
        title: 'קינוחים אישיים',
        description: 'קינוחים אישיים חמים היישר מהתנור עם המון אהבה ‏😊‎'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ ‏',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F51979920-8dec-11eb-9240-0fec2dd2b58d?alt=media&token=cf8e2327-594b-4f68-830c-b4ce0778317c'
        },
      ),
    ];

    return fake[rand.nextInt(fake.length)].copyWith(
      id: rand.nextInt(999999999).toString(),
      cookId: rand.nextInt(999999999).toString(),
      price: Money(
        amount: 10 + (30 * rand.nextDouble()).floorToDouble(),
        currency: const Currency.nis(),
      ),
      tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
    );
  }

  double get _randKm => (rand.nextDouble() * (rand.nextBool() ? 0.1 : -0.1));
}
