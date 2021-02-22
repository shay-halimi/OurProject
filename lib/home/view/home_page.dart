import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          _SearchBtn(),
        ],
      ),
      drawer: _Drawer(user: user),
      body: _MapSample(),
      floatingActionButton: _AddProductScreenBtn(),
    );
  }
}

class _AddProductScreenBtn extends StatelessWidget {
  const _AddProductScreenBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProductScreen()),
        );
      },
      child: Icon(Icons.add),
    );
  }
}

class _SearchBtn extends StatelessWidget {
  const _SearchBtn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('homePage_seach_iconButton'),
      icon: const Icon(Icons.search),
      onPressed: () => null,
      tooltip: "search",
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    /// todo(matan)
    return Drawer();
  }
}

class _MapSample extends StatefulWidget {
  @override
  State<_MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<_MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getMaps(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) =>
          snapshot.hasData ? snapshot.data : Text("Loading.."),
    );
  }

  Future<Widget> getMaps() async {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: (await getUserLocation()),
        zoom: 14.4746,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      zoomControlsEnabled: false,
      markers: Set<Marker>.of([
        Marker(
          markerId: MarkerId(
            "hpme1",
          ),
          position: LatLng(
            37.42796133580614,
            -122.085749655912,
          ),
        ),
        Marker(
          markerId: MarkerId(
            "hpme2",
          ),
          position: LatLng(
            37.42796133580624,
            -122.085749655922,
          ),
        ),
        Marker(
          markerId: MarkerId(
            "hpme3",
          ),
          position: LatLng(
            37.42796133580634,
            -122.085749655932,
          ),
        ),
      ]),
    );
  }

  Future<LatLng> getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return LatLng(0, 0);
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return LatLng(0, 0);
      }
    }

    _locationData = await location.getLocation();

    return LatLng(_locationData.latitude, _locationData.longitude);
  }
}

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add_product_screen"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            tooltip: "search",
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Text("PH"),
              ),
              accountName: Text("accountName"),
              accountEmail: Text("accountEmail"),
            ),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text("local_offer"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("favorite"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("history"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("settings"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text("feedback"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text("bug_report"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: AddProductSample(),
      ),
    );
  }
}

class AddProductSample extends StatefulWidget {
  @override
  State<AddProductSample> createState() => AddProductSampleState();
}

class AddProductSampleState extends State<AddProductSample> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'location_picker',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'photo_picker',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'product_name_input',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'product_price_input',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Are you sure?"),
                            content: Text("all your changes.."),
                            actions: [
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text("yes_close"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("no_im_still_working_on_this"),
                              ),
                            ],
                          )).then(
                      (value) => value ? Navigator.of(context).pop() : null),
                  child: Text("add_product_cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("add_product_ok"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
