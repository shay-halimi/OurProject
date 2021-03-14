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
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectedPointCubit, SelectedPointState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {},
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        if (state.point.isEmpty) {
          return Container();
        }

        return WillPopScope(
          onWillPop: () async {
            context.read<SelectedPointCubit>().selectPoint(Point.empty);
            return false;
          },
          child: CarouselSlider(
            items: widget.points.map((point) {
              return Builder(
                key: Key('CarouselSliderBuilder${point.hashCode}'),
                builder: (context) {
                  return PointWidget(
                    point: point,
                    onTap: () => Navigator.of(context).push<void>(
                      PointPage.route(point: point),
                    ),
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
                      .selectPoint(widget.points.elementAt(index));
                }
              },
              viewportFraction: 0.9,
              height: MediaQuery.of(context).size.height / 3,
            ),
            carouselController: _controller,
          ),
        );
      },
    );
  }
}
