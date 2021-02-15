import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'add_product_screen.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("map_screen"),
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
        child: MapSample(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
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
