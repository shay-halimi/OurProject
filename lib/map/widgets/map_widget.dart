import 'dart:async';

import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    as google_maps_flutter;

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<google_maps_flutter.GoogleMapController> _controller =
      Completer();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocationCubit, LocationState>(
      listenWhen: (previous, current) =>
          previous.status != LocationStateStatus.located &&
          current.status == LocationStateStatus.located,
      listener: (_, state) async {
        if (_controller.future == null) return;

        var controller = await _controller.future;

        await controller.animateCamera(
          google_maps_flutter.CameraUpdate.newLatLng(
            google_maps_flutter.LatLng(
              state.location.latitude,
              state.location.longitude,
            ),
          ),
        );

        context.read<MapCubit>().changePosition(state.location);
      },
      child: BlocBuilder<MapCubit, MapState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return google_maps_flutter.GoogleMap(
            onMapCreated: _controller.complete,
            initialCameraPosition: google_maps_flutter.CameraPosition(
              target: google_maps_flutter.LatLng(
                state.position.latitude,
                state.position.longitude,
              ),
              zoom: 17.5,
            ),
            markers: <google_maps_flutter.Marker>{
              google_maps_flutter.Marker(
                markerId: google_maps_flutter.MarkerId('ME'),
                position: google_maps_flutter.LatLng(
                  state.position.latitude,
                  state.position.longitude,
                ),
                onTap: () => Navigator.of(context).push<void>(
                  ProfilePage.route(),
                ),
              ),
            },
            compassEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          );
        },
      ),
    );
  }
}
