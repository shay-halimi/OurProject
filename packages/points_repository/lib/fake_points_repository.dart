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

  @override
  Stream<List<Point>> near({LatLng latLng, num radiusInKM = 3.14}) async* {
    for (var i = 0; i <= 314; i++) {
      await create(_randPoint.copyWith(
        latLng: LatLng(
          latitude: latLng.latitude + _randDouble,
          longitude: latLng.longitude + _randDouble,
        ),
      ));
    }

    yield* stream();
  }

  @override
  Stream<List<Point>> byCookId(String cookId) async* {
    if (_points.where((point) => point.cookId == cookId).isEmpty) {
      for (var i = 0; i <= rand.nextInt(2); i++) {
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

  void emit() {
    for (var listener in _listeners) listener.add(_points);
  }

  Point get _randPoint {
    final fake = [
      Point.empty.copyWith(
        title: 'כדורי שוקולד',
        description: 'כדורי שוקולד טעימים טעימים עשויים עם המון אהבה ‏😊'
            '\n'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F23f92010-99bd-11eb-b143-6f1872e3afc6?alt=media&token=922a5aa8-49d8-4361-98de-194acc3b8eaf#$_randDouble'
        },
      ),
      Point.empty.copyWith(
        title: 'פיצה ביתית מושלמת!🍕',
        description: '''פיצה טריה עשויה בעבודת יד יום יום מרכיבים טריים

משולש 20 ש''ח 
מגש 6 משולשים - 80 ש''ח 

הזמנות עד יום חמישי ב18:00
ניתן לפנות בוואצאפ או בטלפון ''',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F8478c220-99bc-11eb-b58d-4be2c58fae05?alt=media&token=c91a5dca-903e-4fb7-a0a3-617add1e321e#$_randDouble'
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
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F6d1fe400-99bc-11eb-b58d-4be2c58fae05?alt=media&token=a24f8606-7d4b-449d-a4e6-b505ba6fdf19#$_randDouble'
        },
      ),
      Point.empty.copyWith(
        title: 'קינוחים אישיים',
        description: 'קינוחים אישיים חמים היישר מהתנור עם המון אהבה ‏😊‎'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ ‏',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2Fa1043140-99bc-11eb-b58d-4be2c58fae05?alt=media&token=fdbfbc3c-b6b7-467d-b419-4133e6f18e51#$_randDouble'
        },
      ),
    ];

    return fake[rand.nextInt(fake.length)].copyWith(
      id: _randString,
      cookId: _randString,
      price: Money(
        amount: 10 + (30 * rand.nextDouble()).floorToDouble(),
        currency: Currency.unknown,
      ),
      tags: Point.defaultTags.where((_) => rand.nextBool()).toSet(),
    );
  }

  double get _randDouble =>
      (rand.nextDouble() * (rand.nextBool() ? 0.1 : -0.1));

  String get _randString => rand.nextInt(999999999).toString();
}
