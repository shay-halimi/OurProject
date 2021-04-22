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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
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
              child: GestureDetector(
                onTap: () async => _panelController.isPanelOpen
                    ? await _panelController.close()
                    : await _panelController.open(),
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
  }) : super(key: key);

  final double height;

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
            final cookPoints = {
              if (selectedPoint.cookId == cookId) selectedPoint,
              ...points.where((point) => point.cookId == cookId),
            };

            return Builder(
              key: ValueKey(cookPoints),
              builder: (_) {
                return Card(
                  child: Column(
                    children: [
                      CookWidget(cookId: cookId),
                      Expanded(
                        child: ListView(
                          children: [
                            for (var cookPoint in cookPoints)
                              PointCard(
                                point: cookPoint,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
