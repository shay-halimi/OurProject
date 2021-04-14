import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

final launcher = const _Launcher();

class _Launcher {
  const _Launcher();

  Future<void> email(String emailAddress) {
    return launch('mailto:$emailAddress');
  }

  Future<void> call(String phoneNumber) {
    return launch('tel:$phoneNumber');
  }

  Future<void> whatsApp(String phoneNumber) {
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
}
