import 'dart:async';
import 'dart:math';

import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:location_services/location_services.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key key,
    @required this.location,
    @required this.points,
  }) : super(key: key);

  final Location location;
  final List<Point> points;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<google_maps.GoogleMapController> _controller = Completer();

  double _zoom = 14.5;

  google_maps.BitmapDescriptor _cookpointIcon =
      google_maps.BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    google_maps.BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/cookpoint.png',
    ).then((onValue) {
      _cookpointIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelectedPointCubit, SelectedPointState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (state.point.isEmpty || _controller.future == null) return;

        final controller = await _controller.future;

        await controller.animateCamera(
          google_maps.CameraUpdate.newCameraPosition(
            google_maps.CameraPosition(
              target: google_maps.LatLng(
                state.point.latitude,
                state.point.longitude,
              ),
              bearing: widget.location.heading,
              zoom: _zoom,
            ),
          ),
        );
      },
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        return google_maps.GoogleMap(
          onMapCreated: _controller.complete,
          initialCameraPosition: google_maps.CameraPosition(
            target: google_maps.LatLng(
              widget.location.latitude,
              widget.location.longitude,
            ),
            bearing: widget.location.heading,
            zoom: _zoom,
          ),
          markers: widget.points
              .map((point) => google_maps.Marker(
                    markerId: google_maps.MarkerId(point.id),
                    position: google_maps.LatLng(
                      point.latitude,
                      point.longitude,
                    ),
                    onTap: () {
                      context.read<SelectedPointCubit>().selectPoint(point);
                    },
                    icon: _cookpointIcon,
                  ))
              .toSet(),
          compassEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onTap: (lanLat) =>
              context.read<SelectedPointCubit>().selectPoint(Point.empty),
          onCameraMove: (pos) => _zoom = pos.zoom,
        );
      },
    );
  }
}
