import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key key,
    this.width = 128,
    this.height = 128,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'AppLogo',
      child: Image.asset(
        'assets/images/logo.png',
        width: width,
        height: height,
      ),
    );
  }
}
