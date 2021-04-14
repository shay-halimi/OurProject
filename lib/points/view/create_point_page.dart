import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';

class CreatePointPage extends StatelessWidget {
  const CreatePointPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const CookMiddleware(child: CreatePointPage()));
  }

  @override
  Widget build(BuildContext context) {
    return const PointPage(point: Point.empty);
  }
}
