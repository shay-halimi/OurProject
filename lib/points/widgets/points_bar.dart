import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PointsBar extends StatelessWidget {
  PointsBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

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
  final CarouselController _carouselController = CarouselController();
  final PanelController _panelController = PanelController();

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
          if (state.point.isNotEmpty) {
            _carouselController.jumpToPage(points.indexOf(state.point));
          }
        },
        child: SafeArea(
          child: SlidingUpPanel(
            controller: _panelController,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            borderRadius: BorderRadius.zero,
            minHeight: widget.height * 0.42,
            maxHeight: widget.height * 0.78,
            boxShadow: [],
            color: Colors.transparent,
            panel: CarouselSlider(
              carouselController: _carouselController,
              items: points.map((point) {
                return InkWell(
                  onTap: () async => _panelController.isPanelOpen
                      ? await _panelController.close()
                      : await _panelController.open(),
                  child: Builder(
                    key: ValueKey(point.hashCode),
                    builder: (context) {
                      return PointWidget(point: point);
                    },
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                enableInfiniteScroll: false,
                initialPage: points
                    .indexOf(context.read<SelectedPointCubit>().state.point),
                onPageChanged: (index, reason) {
                  if (reason == CarouselPageChangedReason.manual) {
                    context
                        .read<SelectedPointCubit>()
                        .select(points.elementAt(index));
                  }
                },
                viewportFraction: 0.90,
                height: widget.height,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
