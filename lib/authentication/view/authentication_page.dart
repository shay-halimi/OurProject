import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthenticationPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AuthenticationPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const AppLogo(),
            ElevatedButton(
              child: const Text('אני מאשר את התקנון'),
              onPressed: () => Navigator.of(context).push<void>(
                PhoneNumberPage.route(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
