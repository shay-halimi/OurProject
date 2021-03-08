import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
  final SwiperController _controller = SwiperController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectedPointCubit, SelectedPointState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (widget.points.contains(state.point)) {
          await _controller.move(
            widget.points.indexOf(state.point),
            animation: false,
          );
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        if (widget.points.isEmpty || state.point.isEmpty) {
          return Container();
        }

        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Swiper(
            loop: false,
            itemWidth: MediaQuery.of(context).size.width - 16.0,
            itemBuilder: (_, index) {
              return PointWidget(
                point: widget.points.elementAt(index),
              );
            },
            onIndexChanged: (index) {
              context
                  .read<SelectedPointCubit>()
                  .selectPoint(widget.points.elementAt(index));
            },
            itemCount: widget.points.length,
            viewportFraction: 0.9,
            scale: 0.95,
            controller: _controller,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
