import 'package:cookpoint/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthenticationPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AuthenticationPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('תקנון'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('אני מאשר את התקנון'),
          onPressed: () => Navigator.of(context).push<void>(
            PhoneNumberPage.route(),
          ),
        ),
      ),
    );
  }
}
