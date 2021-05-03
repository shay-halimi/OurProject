import 'dart:async';
import 'dart:math';

import 'foods_repository.dart';

class FakeFoodsRepository extends FoodsRepository {
  final _listeners = <MultiStreamController<List<Food>>>[];

  final List<Food> _foods = [];

  final rand = Random();

  @override
  Future<void> create(Food food) async {
    _foods.add(food.copyWith(
      id: _randString,
      createdAt: Time.now(),
      updatedAt: Time.now(),
    ));

    emit();
  }

  @override
  Future<void> update(Food food) async {
    _foods
      ..removeWhere((f) => f.id == food.id)
      ..add(food.copyWith(
        updatedAt: Time.now(),
      ));

    emit();
  }

  @override
  Future<void> delete(Food food) async {
    return update(food.copyWith(deletedAt: Time.now()));
  }

  @override
  Future<void> restore(Food food) async {
    return update(food.copyWith(deletedAt: Time.empty));
  }

  @override
  Stream<List<Food>> near({LatLng latLng, num radiusInKM = 3.14}) async* {
    for (var i = 0; i <= radiusInKM; i++) {
      final restaurantId = _randString;

      for (var i = 0; i <= rand.nextInt(5); i++) {
        final food = _randFood.copyWith(
          restaurantId: restaurantId,
          latLng: LatLng(
            latitude: latLng.latitude + _randDouble,
            longitude: latLng.longitude + _randDouble,
          ),
        );

        await create(food);

        if (rand.nextBool()) {
          await delete(food);
        }
      }
    }

    yield* stream().map(
      (foods) => foods.where((food) => food.isNotTrashed).toList()
        ..sort(
          (food1, food2) {
            final distance1 = food1.latLng.distanceInKM(latLng);
            final distance2 = food2.latLng.distanceInKM(latLng);

            if (distance1 == distance2) {
              return 0;
            }

            return distance1 < distance2 ? -1 : 1;
          },
        ),
    );
  }

  @override
  Stream<List<Food>> byRestaurantId(String restaurantId) async* {
    if (_foods.where((food) => food.restaurantId == restaurantId).isEmpty) {
      for (var i = 0; i <= 3; i++) {
        await create(
          _randFood.copyWith(
            restaurantId: restaurantId,
          ),
        );
      }
    }

    yield* stream().map((foods) {
      return foods.where((food) => food.restaurantId == restaurantId).toList();
    });
  }

  Stream<List<Food>> stream() {
    return Stream.multi((controller) {
      _listeners.add(controller);

      controller.onCancel = () {
        _listeners.remove(controller);
      };

      emit();
    });
  }

  void emit() {
    final list = _foods.reversed.toList();

    for (var listener in _listeners) listener.add(list);
  }

  Food get _randFood {
    final fake = [
      Food.empty.copyWith(
        title: 'כדורי שוקולד',
        description: 'כדורי שוקולד טעימים טעימים עשויים עם המון אהבה ‏😊'
            '\n'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2F23f92010-99bd-11eb-b143-6f1872e3afc6?alt=media&token=922a5aa8-49d8-4361-98de-194acc3b8eaf#$_randDouble'
        },
      ),
      Food.empty.copyWith(
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
      Food.empty.copyWith(
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
      Food.empty.copyWith(
        title: 'קינוחים אישיים',
        description: 'קינוחים אישיים חמים היישר מהתנור עם המון אהבה ‏😊‎'
            'לפרטים ‏נוספים ‏אפשר ‏להתקשר ‏או ‏לשלוח ‏הודעה ‏לוואטסאפ ‏',
        media: {
          'https://firebasestorage.googleapis.com/v0/b/flutterapp-8f8db.appspot.com/o/gallery%2Fa1043140-99bc-11eb-b58d-4be2c58fae05?alt=media&token=fdbfbc3c-b6b7-467d-b419-4133e6f18e51#$_randDouble'
        },
      ),
    ];

    return fake[rand.nextInt(fake.length)].copyWith(
      price: Money(
        amount: 10 + (30 * rand.nextDouble()).floorToDouble(),
        currency: Currency.unknown,
      ),
      tags: ['ללא גלוטן', 'כשר', 'צמחוני', 'טבעוני']
          .where((_) => rand.nextBool())
          .toSet(),
    );
  }

  double get _randDouble =>
      (rand.nextDouble() * (rand.nextBool() ? 0.1 : -0.1));

  String get _randString => rand.nextInt(999999999).toString();
}
