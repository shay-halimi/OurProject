import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'AppLogo',
      child: Image.asset(
        'assets/images/logo.png',
      ),
    );
  }
}
