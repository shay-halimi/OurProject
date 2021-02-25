import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/home/home.dart';
import 'package:cookpoint/product/create/view/create_page.dart';
import 'package:cookpoint/profile/bloc/bloc.dart';
import 'package:cookpoint/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    context.read<ProfileBloc>()..add(ProfileRequestedEvent(user.phoneNumber));

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

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onTap: (_) => Navigator.of(context).push(ProfilePage.route()),
      compassEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          31.804939,
          35.151100,
        ),
        zoom: 15.00,
      ),
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
