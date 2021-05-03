import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodsBar extends StatelessWidget {
  const FoodsBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FoodsCarousel();
  }
}

class FoodsCarousel extends StatefulWidget {
  const FoodsCarousel({
    Key key,
  }) : super(key: key);

  @override
  _FoodsCarouselState createState() => _FoodsCarouselState();
}

class _FoodsCarouselState extends State<FoodsCarousel> {
  CarouselController controller;

  @override
  void initState() {
    controller = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final foods = context.select((SearchBloc bloc) => bloc.state.results);

    final selected = context.select((SearchBloc bloc) => bloc.state.selected);

    final page = foods.contains(selected) ? foods.indexOf(selected) : 0;

    return BlocListener<SearchBloc, SearchState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (controller.ready && foods.contains(state.selected)) {
          await controller.animateToPage(foods.indexOf(state.selected));
        }
      },
      child: CarouselSlider(
        carouselController: controller,
        key: ValueKey(foods.hashCode),
        items: foods.map(
          (food) {
            return Builder(
              key: Key(food.id),
              builder: (context) {
                return InkWell(
                  onTap: () => Navigator.of(context).push<void>(
                    FoodPage.route(
                      food: food,
                    ),
                  ),
                  child: FoodCard(
                    food: food,
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
              final result = foods.elementAt(index);

              context.read<SearchBloc>().add(SearchResultSelected(result));
            }
          },
          viewportFraction: 0.92,
          aspectRatio: FoodCard.aspectRatio,
        ),
      ),
    );
  }
}
