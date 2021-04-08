import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
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
  final CarouselController _carouselController = CarouselController();
  final PanelController _panelController = PanelController();

  double _height;

  @override
  Widget build(BuildContext context) {
    final points = context.select((SearchBloc bloc) => bloc.state.results);

    return Expanded(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            final maxHeight = constraints.maxHeight;
            final minHeight = constraints.maxHeight * 0.54;

            return WillPopScope(
              onWillPop: () async {
                if (_panelController.isPanelOpen) {
                  await _panelController.close();
                } else {
                  context.read<SelectedPointCubit>().clear();
                }

                return false;
              },
              child: BlocListener<SelectedPointCubit, SelectedPointState>(
                listenWhen: (previous, current) =>
                    previous.point != current.point,
                listener: (_, state) {
                  if (state.point.isNotEmpty) {
                    _carouselController.jumpToPage(points.indexOf(state.point));
                  }
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
                      child: CarouselSlider(
                        carouselController: _carouselController,
                        items: points.map((point) {
                          return Builder(
                            key: ValueKey(point.hashCode),
                            builder: (_) {
                              return PointWidget(
                                point: point,
                                height: _height ?? minHeight,
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          initialPage: points.indexOf(
                              context.read<SelectedPointCubit>().state.point),
                          onPageChanged: (index, reason) {
                            if (reason == CarouselPageChangedReason.manual) {
                              context
                                  .read<SelectedPointCubit>()
                                  .select(points.elementAt(index));
                            }
                          },
                          viewportFraction: 0.92,
                          height: _height ?? minHeight,
                        ),
                      ),
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
