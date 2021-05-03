import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/media/media.dart';
import 'package:flutter/material.dart';

class FoodWidget extends StatelessWidget {
  const FoodWidget({
    Key key,
    @required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 1 / 3;

    return InkWell(
      child: Card(
        key: ValueKey(food.id),
        child: Column(
          children: [
            MediaWidget(
              url: food.media.first,
              maxHeight: maxHeight,
            ),
            ListTile(
              isThreeLine: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        food.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      food.isTrashed
                          ? S.of(context).unavailable
                          : S.of(context).available,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  food.description,
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context).push<void>(
        FoodFormPage.route(food: food),
      ),
    );
  }
}
