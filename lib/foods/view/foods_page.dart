import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodsPage extends StatelessWidget {
  const FoodsPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/foods'),
      builder: (_) => const RestaurantMiddleware(child: FoodsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).foodsPageTitle),
      ),
      body: const FoodsPageBody(),
      floatingActionButton: const CreateFoodButton(),
    );
  }
}

class FoodsPageBody extends StatelessWidget {
  const FoodsPageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodsBloc, FoodsState>(
      buildWhen: (previous, current) =>
          previous.restaurantFoods != current.restaurantFoods,
      builder: (_, state) {
        return ListView(
          children: [
            Card(
              child: ListTile(
                onTap: () => Navigator.of(context)
                    .push<void>(FoodFormPage.route(food: Food.empty)),
                leading: const Icon(Icons.add),
                title: Text(S.of(context).createFoodBtn),
              ),
            ),
            for (var food in state.restaurantFoods)
              FoodWidget(
                food: food,
              ),
          ],
        );
      },
    );
  }
}
