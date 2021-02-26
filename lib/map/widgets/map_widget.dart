import 'dart:async';

import 'package:accounts_repository/accounts_repository.dart';
import 'package:cookpoint/map/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Completer<google_maps_flutter.GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) async {
        if (_controller.future == null) return;

        var controller = await _controller.future;

        controller.moveCamera(
          google_maps_flutter.CameraUpdate.newLatLng(
            google_maps_flutter.LatLng(
              state.location.latitude,
              state.location.longitude,
            ),
          ),
        );
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return google_maps_flutter.GoogleMap(
          onMapCreated: (controller) => _controller.complete(controller),
          initialCameraPosition: google_maps_flutter.CameraPosition(
            target: google_maps_flutter.LatLng(
              state.location.latitude,
              state.location.longitude,
            ),
            zoom: 15,
          ),
          markers: {},
          onCameraMove: (pos) {},
          onTap: (latLng) {
            context.read<MapCubit>().changeCameraPosition(Location(latLng.latitude, latLng.longitude));
          },
          compassEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
        );
      },
    );
  }
}
