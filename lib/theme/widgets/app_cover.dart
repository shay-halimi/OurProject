import 'package:flutter/material.dart';

class AppCover extends StatelessWidget {
  const AppCover({
    Key key,
    this.tag = 'AppCover',
    this.width = 128,
    this.height = 128,
  })  : assert(tag != null),
        assert(width == null || width > 0),
        assert(height == null || height > 0),
        super(key: key);

  final double width;

  final double height;

  final Object tag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Image.asset(
        'assets/images/cover.png',
        width: width,
        height: height,
      ),
    );
  }
}
