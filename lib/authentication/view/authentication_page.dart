import 'package:cookpoint/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthenticationPage extends StatelessWidget {
  static Route route() {
    return PhoneNumberPage.route();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AuthenticationPage"),
      ),
      body: Text("redirect to PhoneNumberPage,"),
    );
  }
}
