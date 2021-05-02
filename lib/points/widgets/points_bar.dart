import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointsBar extends StatelessWidget {
  const PointsBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PointsCarousel();
  }
}

class PointsCarousel extends StatefulWidget {
  const PointsCarousel({
    Key key,
  }) : super(key: key);

  @override
  _PointsCarouselState createState() => _PointsCarouselState();
}

class _PointsCarouselState extends State<PointsCarousel> {
  CarouselController controller;

  @override
  void initState() {
    controller = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final points = context.select((SearchBloc bloc) => bloc.state.results);

    final selected = context.select((SearchBloc bloc) => bloc.state.selected);

    final page = points.contains(selected) ? points.indexOf(selected) : 0;

    return BlocListener<SearchBloc, SearchState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (controller.ready && points.contains(state.selected)) {
          await controller.animateToPage(points.indexOf(state.selected));
        }
      },
      child: CarouselSlider(
        carouselController: controller,
        key: ValueKey(points.hashCode),
        items: points.map(
          (point) {
            return Builder(
              key: Key(point.id),
              builder: (context) {
                return InkWell(
                  onTap: () => Navigator.of(context).push<void>(
                    PointPage.route(
                      point: point,
                    ),
                  ),
                  child: PointCard(
                    point: point,
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
              final result = points.elementAt(index);

              context.read<SearchBloc>().add(SearchResultSelected(result));
            }
          },
          viewportFraction: 0.92,
          aspectRatio: PointCard.aspectRatio,
        ),
      ),
    );
  }
}
