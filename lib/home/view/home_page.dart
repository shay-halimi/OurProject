import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/home/home.dart';
import 'package:cookpoint/location/cubit/cubit.dart';
import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/product/create/view/create_page.dart';
import 'package:cookpoint/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      drawer: SettingsDrawer(),
      body: HomeWidget(),
      floatingActionButton: BlocBuilder<LocationCubit, LocationState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            return FloatingActionButton(
              heroTag: "FloatingActionButtonMyLocation",
              tooltip: "המיקום שלי",
              child: Icon(Icons.my_location),
              onPressed: () {
                context.read<MapCubit>().changeCameraPosition(state.location);
              },
            );
          }),
    );
  }
}

class SettingsDrawer extends StatelessWidget {
  SettingsDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // todo(Matan) account bloc provider here
    return Drawer(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              key: const Key('homePage_AddProductPage'),
              leading: const Icon(Icons.add_location_alt_rounded),
              title: Text("פרסום מוצר"),
              onTap: () => Navigator.of(context).push(AddProductPage.route()),
            ),
            ListTile(
              key: const Key('homePage_MyProfile'),
              leading: const Icon(Icons.face_rounded),
              title: Text("הפרופיל שלי"),
              onTap: () => Navigator.of(context).push(ProfilePage.route()),
            ),
            ListTile(
              key: const Key('homePage_LogoutRequested'),
              leading: const Icon(Icons.exit_to_app),
              title: Text("התנתק"),
              onTap: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWidget(),
        ProductsWidget(),
      ],
    );
  }
}

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SearchAppBar extends AppBar {
  /// todo https://github.com/ArcticZeroo/flutter-search-bar

  SearchAppBar({
    Key key,
  }) : super(
          key: key,
          title: AppTitle(),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => null,
            ),
          ],
        );
}
