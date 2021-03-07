import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:points_repository/points_repository.dart';

class PointsBar extends StatelessWidget {
  const PointsBar({
    Key key,
    @required this.points,
  }) : super(key: key);

  final List<Point> points;

  @override
  Widget build(BuildContext context) {
    return Swiper(
      loop: false,
      itemWidth: MediaQuery.of(context).size.width - 16.0,
      itemBuilder: (_, index) {
        return PointWidget(
          point: points.elementAt(index),
        );
      },
      itemCount: points.length,
      viewportFraction: 0.9,
      scale: 0.95,
    );
  }
}
