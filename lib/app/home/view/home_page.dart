import 'package:cookpoint/account/account.dart' as account;
import 'package:cookpoint/app/app.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/product/product.dart' as product;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      drawer: SettingsDrawer(),
      body: HomeWidget(),
      floatingActionButton: CreateProductButton(),
    );
  }
}

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // todo(Matan) account bloc provider here
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              switch (state.status) {
                case AuthenticationStatus.authenticated:
                  return Column(
                    children: [
                      ListTile(
                        key: const Key('homePage_drawer_my_profile_iconButton'),
                        leading: const Icon(Icons.account_circle),
                        title: Text("חשבון"),
                        onTap: () => Navigator.of(context)
                            .push(account.CreatePage.route()),
                      ),
                      ListTile(
                        key: const Key('homePage_drawer_logout_iconButton'),
                        leading: const Icon(Icons.exit_to_app),
                        title: Text("התנתק"),
                        onTap: () => context
                            .read<AuthenticationBloc>()
                            .add(AuthenticationLogoutRequested()),
                      ),
                      Divider(),
                    ],
                  );
                  break;

                default:
                  return ListTile(
                    key: const Key('homePage_drawer_login_iconButton'),
                    leading: const Icon(Icons.login),
                    title: Text("התחבר"),
                    onTap: () =>
                        Navigator.of(context).push(AuthenticationPage.route()),
                  );
                  break;
              }
            },
          ),
          Divider(),
          ListTile(
            key: const Key('homePage_drawer_bug_report_iconButton'),
            leading: const Icon(Icons.feedback_rounded),
            title: Text("צור קשר"),
            onTap: () => null,
          ),
        ],
      ),
    );
  }
}

class CreateProductButton extends StatelessWidget {
  const CreateProductButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return SpeedDial(
          icon: Icons.list,
          activeIcon: Icons.close,
          curve: Curves.bounceIn,
          overlayOpacity: 0.5,
          tooltip: 'Cook Point',
          heroTag: 'cook-point-here-tag',
          elevation: 8,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.add),
              label: 'פרסם',
              labelStyle: TextStyle(fontSize: 18),
              onTap: () => Navigator.of(context).push<void>(
                product.CreatePage.route(),
              ),
            ),
            SpeedDialChild(
              child: Icon(Icons.my_location),
              label: 'קרוב אליי',
              labelStyle: TextStyle(fontSize: 18),
              onTap: () => Navigator.of(context).push<void>(
                AuthenticationPage.route(),
              ),
            ),
          ],
        );
      },
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

class MapWidget extends StatelessWidget {
  const MapWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      buildingsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          31.804939,
          35.151100,
        ),
        zoom: 15.00,
      ),
      zoomControlsEnabled: false,
      markers: Set<Marker>.of([
        Marker(
          markerId: MarkerId(
            "1",
          ),
          position: LatLng(
            31.804930,
            35.151109,
          ),
        ),
        Marker(
          markerId: MarkerId(
            "1",
          ),
          position: LatLng(
            31.804948,
            35.151119,
          ),
        ),
        Marker(
          markerId: MarkerId(
            "1",
          ),
          position: LatLng(
            31.804920,
            35.151100,
          ),
        ),
      ]),
    );
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
