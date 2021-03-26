import 'package:flutter/material.dart';

class AppCover extends StatelessWidget {
  const AppCover({
    Key key,
    this.width = 128,
    this.height = 128,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'AppCover',
      child: Image.asset(
        'assets/images/cover.png',
        width: width,
        height: height,
      ),
    );
  }
}
