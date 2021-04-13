import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/selected_point/selected_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PointsBar extends StatelessWidget {
  const PointsBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PointsBarView();
  }
}

class PointsBarView extends StatefulWidget {
  const PointsBarView({
    Key key,
  }) : super(key: key);

  @override
  _PointsBarViewState createState() => _PointsBarViewState();
}

class _PointsBarViewState extends State<PointsBarView> {
  final PanelController _panelController = PanelController();

  double _height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            final maxHeight = constraints.maxHeight;
            final minHeight = constraints.maxHeight * 0.54;

            return WillPopScope(
              onWillPop: () async {
                final scaffold = Scaffold.of(context);

                if (scaffold.isDrawerOpen || scaffold.isEndDrawerOpen) {
                  Navigator.of(context).pop();
                } else if (_panelController.isPanelOpen) {
                  await _panelController.close();
                } else {
                  context.read<SelectedPointCubit>().clear();
                }

                return false;
              },
              child: GestureDetector(
                onTap: () async => _panelController.isPanelOpen
                    ? await _panelController.close()
                    : await _panelController.open(),
                child: SlidingUpPanel(
                  controller: _panelController,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  borderRadius: BorderRadius.zero,
                  minHeight: minHeight,
                  maxHeight: maxHeight,
                  boxShadow: [],
                  color: Colors.transparent,
                  onPanelSlide: (position) {
                    setState(() {
                      _height =
                          minHeight + (position * (maxHeight - minHeight));
                    });
                  },
                  panel: Align(
                    alignment: Alignment.topCenter,
                    child: _PointsCarousel(
                      height: _height,
                      minHeight: minHeight,
                      maxHeight: maxHeight,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PointsCarousel extends StatelessWidget {
  _PointsCarousel({
    Key key,
    @required this.height,
    @required this.minHeight,
    @required this.maxHeight,
  }) : super(key: key);

  final double height;

  final double minHeight;

  final double maxHeight;

  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final points = context.select((SearchBloc bloc) => bloc.state.results);

    final point =
        context.select((SelectedPointCubit cubit) => cubit.state.point);

    final page = points.contains(point) ? points.indexOf(point) : 0;

    return BlocListener<SelectedPointCubit, SelectedPointState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) {
        if (_carouselController.ready && points.contains(state.point)) {
          _carouselController.jumpToPage(points.indexOf(state.point));
        }
      },
      child: CarouselSlider(
        carouselController: _carouselController,
        key: ValueKey(points.hashCode),
        items: points.map(
          (point) {
            return Builder(
              builder: (_) {
                return PointCard(
                  key: ValueKey(point.hashCode),
                  point: point,
                  height: height ?? minHeight,
                  minHeight: minHeight,
                  maxHeight: maxHeight,
                );
              },
            );
          },
        ).toList(),
        options: CarouselOptions(
          enableInfiniteScroll: false,
          initialPage: page,
          onPageChanged: (index, reason) {
            if (reason == CarouselPageChangedReason.manual) {
              context
                  .read<SelectedPointCubit>()
                  .select(points.elementAt(index));
            }
          },
          viewportFraction: 0.92,
          height: height ?? minHeight,
        ),
      ),
    );
  }
}
