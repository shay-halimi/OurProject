import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class RestaurantPage extends StatelessWidget {
  const RestaurantPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/restaurants/me'),
      builder: (_) => const RestaurantMiddleware(
        child: RestaurantPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).accountPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                Navigator.of(context).push<void>(RestaurantFormPage.route()),
          ),
        ],
      ),
      body: const RestaurantPageBody(),
    );
  }
}

class RestaurantPageBody extends StatelessWidget {
  const RestaurantPageBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurant =
        context.select((RestaurantBloc bloc) => bloc.state.restaurant);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: PhotoURLWidget(
                photoURL: restaurant.photoURL,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                ListTile(
                  title: Text(restaurant.displayName),
                  subtitle: Text(S.of(context).displayName),
                ),
                ListTile(
                  title: Text(restaurant.address.name),
                  subtitle: Text(S.of(context).address),
                ),
                ListTile(
                  title: Text(humanz.phoneNumber(restaurant.phoneNumber)),
                  subtitle: Text(S.of(context).phoneNumber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
