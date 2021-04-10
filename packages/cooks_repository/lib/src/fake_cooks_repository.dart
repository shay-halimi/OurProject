import 'dart:async';
import 'dart:math';

import 'cooks_repository.dart';
import 'models/models.dart';

class FakeCooksRepository implements CooksRepository {
  final _listeners = <MultiStreamController<List<Cook>>>[];

  final List<Cook> _cooks = [];

  final rand = Random();

  @override
  Stream<Cook> cook(String id) async* {
    if (_cooks.where((cook) => cook.id == id).isEmpty) {
      await create(Cook(
        id: id,
        displayName: _randName,
        address: Address(
          name: _randAddress,
          latitude: 35,
          longitude: 17,
        ),
        phoneNumber: '+97212345${1000 + rand.nextInt(8999)}',
        photoURL: 'https://i.pravatar.cc/300#$id',
      ));
    }

    yield* stream().map((cooks) {
      return cooks.where((cooks) => cooks.id == id).first;
    });
  }

  @override
  Future<void> create(Cook cook) async {
    _cooks.add(cook);
    emit();
  }

  @override
  Future<void> update(Cook cook) async {
    _cooks.removeWhere((_cook) => _cook.id == cook.id);
    return create(cook);
  }

  Stream<List<Cook>> stream() {
    return Stream.multi((controller) {
      _listeners.add(controller);

      controller.onCancel = () {
        _listeners.remove(controller);
      };

      emit();
    });
  }

  void emit() {
    for (var listener in _listeners) listener.add(_cooks);
  }

  static const _fNames = [
    'דוד',
    'אריאל',
    'לביא',
    'נועם',
    'יוסף',
    'אורי',
    'איתן',
    'משה',
    'רפאל',
    'ארי',
    'יהודה',
    'איתי',
    'דניאל',
    'אברהם',
    'ישראל',
    'יהונתן',
    'שמואל',
    'אליה',
    'אהרון',
    'יצחק',
    'מיכאל',
    'עומר',
    'יעקב',
    'יונתן',
    'חיים',
    'איתמר',
    'שמעון',
    'שלמה',
    'יאיר',
    'עידו',
    'ינאי',
    'אדם',
    'אלון',
    'בניה',
    'אימרי',
    'הראל',
    'ניתאי',
    'מאיר',
    'ישי',
    'תמר',
    'מאיה',
    'נועה',
    'אביגיל',
    'איילה',
    'יעל',
    'שרה',
    'אדל',
    'שירה',
    'אסתר',
    'חנה',
    'רבקה',
    'ליה',
    'רחל',
    'רוני',
    'רומי',
    'אלה',
    'חיה',
    'מיכל',
    'טליה',
    'נויה',
    'מרים',
    'אמה',
    'עלמה',
    'רות',
    'הלל',
    'ליבי',
    'יובל',
    'הודיה',
    'אריאל',
    'נעמי',
    'אגם',
    'טוהר',
    'עומר',
    'גאיה',
    'גפן',
    'אורי',
    'לי-שי',
    'נגה',
  ];

  static const _lNames = [
    'כהן',
    'לוי',
    'מזרחי',
    'פרץ',
    'ביטון',
    'דהן',
    'אברהם',
    'אגבאריה',
    'פרידמן',
  ];

  static const _addresses = <String>[
    'אבו גוש',
    'אבטין',
    'אביאל',
    'אביבים',
    'אביגדור',
    'אביחיל',
    'אביטל',
    'אביעזר',
    'אבירים',
    'אבן יהודה',
    'אבן מנחם',
    'אבן ספיר',
    'אבני איתן',
    'אבני חפץ',
    'אבנת',
    'אבשלום',
    'אדורה',
    'אדירים',
    'אדמית',
    'אדרת',
    'אוגדה',
    'אודים',
    'אודם',
    'אוהד',
    'אום בטין',
    'אופקים',
    'אור הגנוז',
    'אור הנר',
    'אור יהודה',
    'אור עקיבא',
    'אורה',
    'איילת השחר',
    'אילון',
    'אילות',
    'אילניה',
    'אילת',
    'אירוס',
    'איתמר',
    'איתן',
    'אכסאל',
    'אל עזי',
    'אל-עריאן',
    'אל-רום',
    'אלומה',
    'אלומות',
    'אלון הגליל',
    'אלונים',
    'אלמגור',
    'אלמוג',
    'אלעד',
    'אלעזר',
    'אפיניש',
    'אפיק',
    'אפיקים',
    'אפק',
    'אפרת',
    'ארבל',
    'ארגמן',
    'ארז',
    'אריאל',
    'ארסוף',
    'אשבול',
    'אשבל',
    'אשדוד',
    'אשדות יעקב איחוד',
    'אשדות יעקב מאוחד',
    'אשחר',
    'אשכולות',
    'אשל הנשיא',
    'אשלים',
    'אשקלון',
    'ביריה',
    'בית אורן',
    'בית אל',
    'בית אלעזרי',
    'בית אלפא',
    'בית אריה-עופרים',
    'בית ברל',
    'בית גוברין',
    'בית גמליאל',
    'בית דגן',
    'בית הגדי',
    'בית הלוי',
    'בית הלל',
    'בית הערבה',
    'בית השיטה',
    'בית זייד',
    'בית זית',
    'בית זרע',
    'בית חגי',
    'בית חלקיה',
    'בית חנניה',
    'בית חרות',
    'בית חשמונאי',
    'בית יהושע',
    'בית יוסף',
    'בני ציון',
    'בני ראם',
    'בניה',
    'בצת',
    'בקוע',
    'בקעות',
    'בר גיורא',
    'בר יוחאי',
    'ברוכין',
    'ברור חיל',
    'ברוש',
    'ברכיה',
    'ברעם',
    'ברק',
    'ברקאי',
    'ברקן',
    'ברקת',
    'בת הדר',
    'בת חן',
    'גבע בנימין',
    'גבע כרמל',
    'גבעת זאב',
    'גבעת ח"ן',
    'גבעת חביבה',
    'גבעת חיים איחוד',
    'גזית',
    'גזר',
    'גיאה',
    'גיזו',
    'גילון',
    'גילת',
    'גינוסר',
    'גן שמואל',
    'גנות',
    'גני הדר',
    'גני טל',
    'גני יוחנן',
    'גני מודיעין',
    'גני עם',
    'גני תקווה',
    'גניגר',
    'גנתון',
    'זמר',
    'זמרת',
    'זנוח',
    'חגור',
    'חגלה',
    'חד נס',
    'חדיד',
    'חדרה',
    'חוות יאיר',
    'חולדה',
    'חולון',
    'חולית',
    'חולתה',
    'חוסן',
    'חוסנייה',
    'חופית',
    'חוקוק',
    'חורה',
    'חורפיש',
    'חורשים',
    'חזון',
    'חיבת ציון',
    'חיננית',
    'חיספין',
    'חיפה',
    'חצור הגלילית',
    'חצרים',
    'חרב לאת',
    'חרוצים',
    'חרות',
    'חריש',
    'חרמש',
    'טירת צבי',
    'טל שחר',
    'טל-אל',
    'טללים',
    'יבול',
    'יבנאל',
    'יבנה',
    'יגור',
    'יגל',
    'יד בנימין',
    'יד השמונה',
  ];

  String get _randName => '${_fNames[rand.nextInt(_fNames.length)]} '
      '${_lNames[rand.nextInt(_lNames.length)]}';

  String get _randAddress => _addresses[rand.nextInt(_addresses.length)];
}
