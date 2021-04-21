import 'package:cookpoint/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/authentication'),
      builder: (_) => const AuthenticationPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}
