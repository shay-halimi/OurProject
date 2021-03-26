import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:points_repository/points_repository.dart';

class PointsBar extends StatelessWidget {
  PointsBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.38;

    return BlocBuilder<SelectedPointCubit, SelectedPointState>(
      buildWhen: (previous, current) => previous.point != current.point,
      builder: (_, state) {
        if (state.point.isEmpty) {
          return Container();
        }

        return PointsBarView(
          height: height,
        );
      },
    );
  }
}

class PointsBarView extends StatefulWidget {
  const PointsBarView({
    Key key,
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  _PointsBarViewState createState() => _PointsBarViewState();
}

class _PointsBarViewState extends State<PointsBarView> {
  final CarouselController _controller = CarouselController();
  Point _selectedPoint = Point.empty;

  @override
  Widget build(BuildContext context) {
    final points = context.select((SearchBloc bloc) => bloc.state.results);

    return WillPopScope(
      onWillPop: () async {
        context.read<SelectedPointCubit>().clear();
        return false;
      },
      child: BlocListener<SelectedPointCubit, SelectedPointState>(
        listenWhen: (previous, current) => previous.point != current.point,
        listener: (_, state) {
          if (_selectedPoint.isNotEmpty && _selectedPoint != state.point) {
            _selectedPoint = state.point;
            _controller.jumpToPage(points.indexOf(_selectedPoint));
          }
        },
        child: SafeArea(
          child: CarouselSlider(
            carouselController: _controller,
            items: points.map((point) {
              return Builder(
                key: ValueKey(point.id),
                builder: (context) {
                  return PointWidget(
                    point: point,
                    onTap: () => Navigator.of(context).push<void>(
                      PointPage.route(point: point),
                    ),
                    height: widget.height,
                  );
                },
              );
            }).toList(),
            options: CarouselOptions(
              enableInfiniteScroll: false,
              initialPage: points
                  .indexOf(context.read<SelectedPointCubit>().state.point),
              onPageChanged: (index, reason) {
                _selectedPoint = points.elementAt(index);
                if (reason == CarouselPageChangedReason.manual) {
                  context.read<SelectedPointCubit>().select(_selectedPoint);
                }
              },
              viewportFraction: 0.90,
              height: widget.height,
            ),
          ),
        ),
      ),
    );
  }
}
