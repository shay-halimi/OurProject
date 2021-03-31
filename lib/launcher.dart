import 'dart:io';

import 'package:cooks_repository/cooks_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

final launcher = _Launcher();

class _Launcher {
  Future<void> email(String emailAddress) {
    return launch('mailto:$emailAddress');
  }

  Future<void> call(String phoneNumber) {
    return launch('tel:$phoneNumber');
  }

  Future<void> whatsapp(String phoneNumber) {
    return launch('https://wa.me/$phoneNumber');
  }

  Future<void> launch(String url) async {
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

  Future<void> directions(Address address) {
    bool isIOS;
    try {
      isIOS = Platform.isIOS;
    } catch (e) {
      isIOS = false;
    }

    return launch(isIOS
        ? 'https://maps.apple.com/?center=${address.latitude},${address.longitude}&q=${address.name}'
        : 'https://maps.google.com/?center=${address.latitude},${address.longitude}&q=${address.name}');
  }
}
