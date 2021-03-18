import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

final launcher = _Launcher();

class _Launcher {
  Future<void> email(String emailAddress) async {
    if (Platform.isAndroid) {
      try {
        final intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.APP_EMAIL',
          arguments: <String, dynamic>{
            'android.intent.extra.EMAIL': emailAddress,
          },
        );

        await intent.launch();
      } on Exception {
        await web('mailto:$emailAddress');
      }
    } else if (Platform.isIOS) {
      await web('mailto:$emailAddress');
    }
  }

  Future<void> dial(String phoneNumber) async {
    if (Platform.isAndroid) {
      try {
        final intent = AndroidIntent(
          action: 'android.intent.action.DIAL',
          data: phoneNumber,
        );

        await intent.launch();
      } on Exception {
        await web('tel:$phoneNumber');
      }
    } else if (Platform.isIOS) {
      await web('tel:$phoneNumber');
    }
  }

  Future<void> web(String url) async {
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      await Fluttertoast.showToast(
        msg: 'המכשיר שלך לא תומך בפעולה זאת',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }
}
