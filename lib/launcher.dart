import 'package:cookpoint/cook/cook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;
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

  Future<void> directions(BuildContext context, Address address) async {
    final installedMaps = await map_launcher.MapLauncher.installedMaps;

    if (installedMaps.isEmpty) {
      await Fluttertoast.showToast(
        msg: 'המכשיר שלך לא תומך בפעולה זאת',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    } else {
      if (installedMaps.length == 1) {
        await installedMaps.first.showMarker(
          coords: map_launcher.Coords(address.latitude, address.longitude),
          title: address.name,
        );
      } else {
        await showModalBottomSheet<map_launcher.AvailableMap>(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Wrap(
                    children: [
                      for (var map in installedMaps)
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop(map);
                          },
                          title: Text(map.mapName),
                          leading: SvgPicture.asset(
                            map.icon,
                            height: 24.0,
                            width: 24.0,
                          ),
                          trailing: const Icon(
                              LineAwesomeIcons.alternate_external_link),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ).then(
          (map) => map?.showMarker(
            coords: map_launcher.Coords(address.latitude, address.longitude),
            title: address.name,
          ),
        );
      }
    }
  }
}
