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
        title: Text("תקנון"),
      ),
      body: Center(
        child: TextButton(
          child: Text("אני מאשר את התקנון"),
          onPressed: () => Navigator.of(context).push(PhoneNumberPage.route()),
        ),
      ),
    );
  }
}
