import 'dart:async';

import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/profiles/profiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<google_maps.GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    return BlocListener<PointsBloc, PointsState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (_controller.future == null) return;

        for (var point in state.points) {
          if (point.id == user.id) {
            var controller = await _controller.future;

            await controller.animateCamera(
              google_maps.CameraUpdate.newLatLng(
                google_maps.LatLng(
                  point.location.latitude,
                  point.location.longitude,
                ),
              ),
            );
          }
        }
      },
      child: BlocBuilder<PointsBloc, PointsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return google_maps.GoogleMap(
            onMapCreated: _controller.complete,
            initialCameraPosition: const google_maps.CameraPosition(
              target: google_maps.LatLng(0, 0),
              zoom: 17.5,
            ),
            markers: state.points
                .map((point) => google_maps.Marker(
                      markerId: google_maps.MarkerId(point.id),
                      position: google_maps.LatLng(
                        point.location.latitude,
                        point.location.longitude,
                      ),
                      onTap: () =>
                          Navigator.of(context).push<void>(ProfilePage.route()),
                      icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                        point.available
                            ? google_maps.BitmapDescriptor.hueGreen
                            : google_maps.BitmapDescriptor.hueRed,
                      ),
                    ))
                .toSet(),
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
