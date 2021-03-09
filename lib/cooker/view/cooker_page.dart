import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/media/media_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CookerPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CookerPage());
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationPage();
  }
}

class _CookerView extends StatelessWidget {
  const _CookerView({
    Key key,
    @required this.cooker,
  }) : super(key: key);

  final Cooker cooker;

  @override
  Widget build(BuildContext context) {
    final _whatsappURL = 'https://wa.me/${cooker.phoneNumber}';
    final _phoneNumberURL = 'tel:${cooker.phoneNumber}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('החשבון שלי'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MediaWidget(media: cooker.photoURL),
          Text(cooker.displayName),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () async => await canLaunch(_whatsappURL)
                      ? await launch(_whatsappURL)
                      : null,
                  icon: const Icon(FontAwesomeIcons.whatsapp),
                  label: const Text('שלח הודעה'),
                ),
              ),
              Expanded(
                child: TextButton.icon(
                  onPressed: () async => await canLaunch(_phoneNumberURL)
                      ? await launch(_phoneNumberURL)
                      : null,
                  icon: const Icon(FontAwesomeIcons.phone),
                  label: const Text('התקשר'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
