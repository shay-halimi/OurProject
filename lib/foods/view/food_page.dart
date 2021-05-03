import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/imagez.dart';
import 'package:cookpoint/launcher.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;
import 'package:provider/provider.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({
    Key key,
    @required this.food,
  }) : super(key: key);

  final Food food;

  static Route route({
    @required Food food,
  }) {
    return MaterialPageRoute<void>(
      settings: RouteSettings(name: '/foods/${food.id}'),
      builder: (_) => FoodPage(
        food: food,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final center =
        context.select((LocationCubit location) => location.state.toLatLng());

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              BlocProvider(
                create: (_) => RestaurantWidgetCubit(
                  restaurantId: food.restaurantId,
                  restaurantsRepository: context.read<RestaurantsRepository>(),
                ),
                child:
                    BlocBuilder<RestaurantWidgetCubit, RestaurantWidgetState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (_, state) {
                    final restaurant = state is RestaurantWidgetLoaded
                        ? state.restaurant
                        : Restaurant.empty;

                    final height = MediaQuery.of(context).size.height;

                    return Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: height * 0.2,
                                    maxHeight: height * 0.8,
                                  ),
                                  child: Image(
                                    image: imagez.url(food.media.first),
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (_, child, loadingProgress) {
                                      return loadingProgress == null
                                          ? child
                                          : const LinearProgressIndicator();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            title: Text(
                              food.title,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            subtitle: TagsLine(
                              tags: {
                                S.of(context).kmFromYou(
                                    humanz.distance(food.latLng, center)),
                                ...food.tags,
                              },
                            ),
                            trailing: food.price.isEmpty
                                ? null
                                : Text(
                                    humanz.money(food.price),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                RestaurantWidget(
                                  restaurant: restaurant,
                                ),
                                if (food.description.isNotEmpty)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(food.description),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await FirebaseAnalytics().logEvent(
                                      name: 'lead',
                                      parameters: <String, dynamic>{
                                        'restaurant': restaurant.id,
                                        'food': food.id,
                                        'value': food.price.amount,
                                        'phone': restaurant.phoneNumber,
                                        'type': 'whatsApp',
                                      },
                                    );
                                    return launcher
                                        .whatsApp(restaurant.phoneNumber);
                                  },
                                  label: Text(S.of(context).whatsAppBtn),
                                  icon: const Icon(LineAwesomeIcons.what_s_app),
                                ),
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await FirebaseAnalytics().logEvent(
                                      name: 'lead',
                                      parameters: <String, dynamic>{
                                        'restaurant': restaurant.id,
                                        'food': food.id,
                                        'value': food.price.amount,
                                        'phone': restaurant.phoneNumber,
                                        'type': 'phone',
                                      },
                                    );
                                    return launcher
                                        .call(restaurant.phoneNumber);
                                  },
                                  label: Text(S.of(context).phoneBtn),
                                  icon: const Icon(LineAwesomeIcons.phone),
                                ),
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await FirebaseAnalytics().logEvent(
                                      name: 'lead',
                                      parameters: <String, dynamic>{
                                        'restaurant': restaurant.id,
                                        'food': food.id,
                                        'value': food.price.amount,
                                        'phone': restaurant.phoneNumber,
                                        'type': 'directions',
                                      },
                                    );
                                    return showModalBottomSheet<
                                        map_launcher.AvailableMap>(
                                      context: context,
                                      builder: (_) {
                                        return _DirectionsDialog(
                                          restaurant: restaurant,
                                        );
                                      },
                                    );
                                  },
                                  label: Text(S.of(context).directionsBtn),
                                  icon: const Icon(LineAwesomeIcons.directions),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _Suggestions(
                food: food,
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                const SafeArea(
                  child: CloseButton(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({
    Key key,
    @required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    final suggestions = context
        .select((FoodsBloc bloc) => bloc.state.nearbyFoods)
        .where((e) => e.restaurantId == food.restaurantId)
        .toList()
          ..remove(food);

    return Column(
      children: [
        for (var suggestion in suggestions)
          InkWell(
            onTap: () => Navigator.of(context).pushReplacement<void, void>(
              FoodPage.route(
                food: suggestion,
              ),
            ),
            child: FoodCard(
              food: suggestion,
            ),
          ),
      ],
    );
  }
}

class _DirectionsDialog extends StatelessWidget {
  const _DirectionsDialog({
    Key key,
    @required this.restaurant,
  }) : super(key: key);

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<map_launcher.AvailableMap>>(
      future: map_launcher.MapLauncher.installedMaps,
      builder: (_, snapshot) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: snapshot.hasData
                  ? Wrap(
                      children: [
                        for (var map in snapshot.data) _map(context, map),
                      ],
                    )
                  : const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _map(BuildContext context, map_launcher.AvailableMap map) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Text(map.mapName),
      leading: Icon(map.iconData),
      onTap: () async {
        await map
            .showMarker(
              coords: map_launcher.Coords(
                restaurant.address.latitude,
                restaurant.address.longitude,
              ),
              title: restaurant.address.name,
            )
            .then((value) => Navigator.of(context).pop());
      },
    );
  }
}

extension _XMap on map_launcher.AvailableMap {
  IconData get iconData {
    switch (mapType) {
      case map_launcher.MapType.waze:
        return LineAwesomeIcons.waze;

      default:
        return LineAwesomeIcons.directions;
    }
  }
}
