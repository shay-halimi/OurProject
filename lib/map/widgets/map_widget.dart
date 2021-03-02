import 'dart:async';
import 'dart:math';

import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/profiles/profiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:points_repository/points_repository.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<google_maps.GoogleMapController> _controller = Completer();

  double zoom = 17.5;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (_controller.future == null) return;

        if (state.status == MapStateStatus.loaded) {
          final controller = await _controller.future;

          await controller.animateCamera(
            google_maps.CameraUpdate.newCameraPosition(
              google_maps.CameraPosition(
                target: google_maps.LatLng(
                  state.location.latitude,
                  state.location.longitude,
                ),
                bearing: state.location.heading,
                zoom: zoom,
              ),
            ),
          );
        }
      },
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return google_maps.GoogleMap(
          onMapCreated: _controller.complete,
          initialCameraPosition: google_maps.CameraPosition(
            target: google_maps.LatLng(
              state.location.latitude,
              state.location.longitude,
            ),
            bearing: state.location.heading,
            zoom: zoom,
          ),
          markers: context
              .select((PointsBloc bloc) => bloc.state.points)
              .map((point) => google_maps.Marker(
                    markerId: google_maps.MarkerId(point.id),
                    position: google_maps.LatLng(
                      point.latitude,
                      point.longitude,
                    ),
                    onTap: () =>
                        Navigator.of(context).push<void>(ProfilePage.route()),
                    icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                      point.available
                          ? google_maps.BitmapDescriptor.hueGreen
                          : google_maps.BitmapDescriptor.hueRed,
                    ),
                  ))
              .toSet()
                ..add(
                  google_maps.Marker(
                    markerId: google_maps.MarkerId('LOCATION_INDICATOR'),
                    position: google_maps.LatLng(
                      state.location.latitude,
                      state.location.longitude,
                    ),
                    icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                      google_maps.BitmapDescriptor.hueAzure,
                    ),
                    onTap: () {
                      zoom = 17.5;
                      context.read<MapCubit>().updateLocation(state.location);
                    },
                  ),
                ),
          compassEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onTap: (lanLat) => context.read<PointsBloc>().add(
                PointCreatedEvent(
                  Point.empty.copyWith(
                    available: Random().nextBool(),
                    latitude: lanLat.latitude,
                    longitude: lanLat.longitude,
                  ),
                ),
              ),
          onCameraMove: (pos) => zoom = pos.zoom,
        );
      },
    );
  }
}
