import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';

class CreatePointPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => CookMiddleware(child: CreatePointPage()));
  }

  @override
  Widget build(BuildContext context) {
    return const PointPage(point: Point.empty);
  }
}
