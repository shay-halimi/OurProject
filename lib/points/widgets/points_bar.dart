import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookpoint/cook/cook.dart';
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
    return BlocProvider(
      create: (_) => PointsBarCubit(),
      child: const PointsBarView(),
    );
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (_, constraints) {
          final height = constraints.maxHeight;

          return WillPopScope(
            onWillPop: () async {
              final scaffold = Scaffold.of(context);

              if (scaffold.isDrawerOpen || scaffold.isEndDrawerOpen) {
                Navigator.of(context).pop();
              } else if (_panelController.isAttached &&
                  _panelController.isPanelOpen) {
                await _panelController.close();
              } else {
                context.read<SelectedPointCubit>().clear();
              }

              return false;
            },
            child: SlidingUpPanel(
              controller: _panelController,
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              borderRadius: BorderRadius.zero,
              maxHeight: height,
              minHeight: height * 0.54,
              boxShadow: [],
              color: Colors.transparent,
              panel: Align(
                alignment: Alignment.topCenter,
                child: _PointsCarousel(
                  height: height,
                  onHeaderTap: () async => _panelController.isPanelOpen
                      ? await _panelController.close()
                      : await _panelController.open(),
                ),
              ),
              onPanelOpened: () {
                context.read<PointsBarCubit>().enable();
              },
              onPanelClosed: () {
                context.read<PointsBarCubit>().disable();
              },
            ),
          );
        },
      ),
    );
  }
}

class _PointsCarousel extends StatelessWidget {
  _PointsCarousel({
    Key key,
    @required this.height,
    @required this.onHeaderTap,
  }) : super(key: key);

  final double height;

  final VoidCallback onHeaderTap;

  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final points = context.select((SearchBloc bloc) => bloc.state.results);

    final cookIds = points.map((point) => point.cookId).toSet().toList();

    final selectedPoint =
        context.select((SelectedPointCubit cubit) => cubit.state.point);

    final page = cookIds.contains(selectedPoint.cookId)
        ? cookIds.indexOf(selectedPoint.cookId)
        : 0;

    return BlocListener<SelectedPointCubit, SelectedPointState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) {
        if (_carouselController.ready && cookIds.contains(state.point.cookId)) {
          _carouselController.jumpToPage(cookIds.indexOf(state.point.cookId));
        }
      },
      child: CarouselSlider(
        carouselController: _carouselController,
        key: ValueKey(cookIds),
        items: cookIds.map(
          (cookId) {
            final cookPoints =
                points.where((point) => point.cookId == cookId).toList()
                  ..sort((point1, point2) {
                    if (point1.id == selectedPoint.id) return -1;

                    if (point2.id == selectedPoint.id) return 1;

                    return 0;
                  });

            return Builder(
              key: ValueKey(cookPoints),
              builder: (_) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: onHeaderTap,
                      child: Card(
                        child: CookWidget(cookId: cookId),
                      ),
                    ),
                    Expanded(
                      child: Feed(cookPoints: cookPoints),
                    ),
                  ],
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
              context.read<SelectedPointCubit>().select(points.firstWhere(
                  (point) => point.cookId == cookIds.elementAt(index)));
            }
          },
          viewportFraction: 0.92,
          height: height,
        ),
      ),
    );
  }
}

class Feed extends StatelessWidget {
  const Feed({
    Key key,
    @required this.cookPoints,
  }) : super(key: key);

  final List<Point> cookPoints;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointsBarCubit, PointsBarState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        return ListView(
          physics: state.status == PointsBarStatus.scrollable
              ? null
              : const NeverScrollableScrollPhysics(),
          children: [
            for (var cookPoint in cookPoints)
              PointCard(
                key: Key(cookPoint.id),
                point: cookPoint,
              ),
          ],
        );
      },
    );
  }
}
