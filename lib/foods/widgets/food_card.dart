import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/imagez.dart';
import 'package:cookpoint/location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    Key key,
    @required this.food,
  }) : super(key: key);

  final Food food;

  static const double aspectRatio = 3 / 2;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Image(
                      image: imagez.url(food.media.first),
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : const LinearProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            ),
            _Footer(
              food: food,
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    Key key,
    @required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    final center =
        context.select((LocationCubit cubit) => cubit.state.toLatLng());

    return ListTile(
      title: Text(food.title),
      subtitle: TagsLine(
        tags: {
          S.of(context).kmFromYou(humanz.distance(food.latLng, center)),
          ...food.tags,
        },
      ),
      trailing: food.price.isEmpty
          ? null
          : Text(
              humanz.money(food.price),
              style: Theme.of(context).textTheme.bodyText1,
            ),
    );
  }
}
