import 'package:cookpoint/cook/cook.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_launcher/map_launcher.dart';
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

  Future<void> directions(Address address) async {
    final availableMaps = await MapLauncher.installedMaps;

    if (availableMaps.isEmpty) {
      await Fluttertoast.showToast(
        msg: 'המכשיר שלך לא תומך בפעולה זאת',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } else {
      await availableMaps.first.showMarker(
        coords: Coords(address.latitude, address.longitude),
        title: address.name,
      );
    }
  }
}
