import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';

class PointsBar extends StatefulWidget {
  PointsBar({
    Key key,
    @required this.points,
  }) : super(key: key);

  final List<Point> points;

  @override
  _PointsBarState createState() => _PointsBarState();
}

class _PointsBarState extends State<PointsBar> {
  List<Point> get points => widget.points;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.4;
    final CarouselController _controller = CarouselController();

    return BlocConsumer<SelectedPointCubit, SelectedPointState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (points.contains(state.point)) {
          if (_controller.ready) {
            try {
              await _controller.animateToPage(points.indexOf(state.point));
            } on Error {
              print('bug in carousel_slider?');
            }
          }
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        return WillPopScope(
          onWillPop: () async {
            if (state.point.isNotEmpty) {
              context.read<SelectedPointCubit>().selectPoint(Point.empty);
              return false;
            }
            return true;
          },
          child: Visibility(
            visible: state.point.isNotEmpty,
            child: CarouselSlider(
              carouselController: _controller,
              items: points.map((point) {
                return Builder(
                  key: Key('${point.hashCode}_points_bar_point_widget_builder'),
                  builder: (context) {
                    return PointWidget(
                      point: point,
                      onTap: () => Navigator.of(context).push<void>(
                        PointPage.route(point: point),
                      ),
                      height: height,
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                enableInfiniteScroll: false,
                initialPage: widget.points.contains(state.point)
                    ? widget.points.indexOf(state.point)
                    : 0,
                onPageChanged: (index, reason) {
                  if (reason == CarouselPageChangedReason.manual) {
                    context
                        .read<SelectedPointCubit>()
                        .selectPoint(points.elementAt(index));
                  }
                },
                viewportFraction: 0.94,
                height: height,
              ),
            ),
          ),
        );
      },
    );
  }
}
