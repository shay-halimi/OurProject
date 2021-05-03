import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:flutter/material.dart';

class CreateFoodButton extends StatelessWidget {
  const CreateFoodButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'FloatingActionButtonRestaurantFood',
      label: Text(S.of(context).createFoodBtn),
      onPressed: () {
        Navigator.of(context).push<void>(FoodFormPage.route(food: Food.empty));
      },
    );
  }
}
