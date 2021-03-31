import 'dart:async';
import 'dart:io';

import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as g_maps;
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({
    Key key,
    @required this.pixelRatio,
  }) : super(key: key);

  final double pixelRatio;

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final Completer<g_maps.GoogleMapController> _controller = Completer();

  double _zoom = 8.0;
  double _heading = 0;

  g_maps.BitmapDescriptor _pointMarker = g_maps.BitmapDescriptor.defaultMarker;

  g_maps.BitmapDescriptor _selectedPointMarker =
      g_maps.BitmapDescriptor.defaultMarker;

  double get _pixelRatio => widget.pixelRatio;

  bool _ready = false;

  @override
  void initState() {
    super.initState();

    var _size = 64;

    bool isIOS;
    try {
      isIOS = Platform.isIOS;
    } catch (e) {
      isIOS = false;
    }

    if (!isIOS) {
      if (_pixelRatio >= 1.5) {
        _size = _size * 2;
      } else if (_pixelRatio >= 2.5) {
        _size = _size * 3;
      } else if (_pixelRatio >= 3.5) {
        _size = _size * 4;
      }
    }

    g_maps.BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/mini_marker_$_size.png')
        .then((value) => setState(() => _pointMarker = value));

    g_maps.BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/marker_$_size.png')
        .then((value) => setState(() => _selectedPointMarker = value));
  }

  @override
  Widget build(BuildContext context) {
    final points = context.select((SearchBloc bloc) => bloc.state.results);

    final location = context.select((LocationCubit cubit) => cubit.state);

    final center = points.isEmpty
        ? g_maps.LatLng(
            location.latitude,
            location.longitude,
          )
        : g_maps.LatLng(
            points.first.latLng.latitude,
            points.first.latLng.longitude,
          );

    return Opacity(
      opacity: _ready ? 1 : 0,
      child: BlocConsumer<SelectedPointCubit, SelectedPointState>(
        listenWhen: (previous, current) => previous != current,
        listener: (_, state) async {
          if (state.point.isEmpty || _controller.future == null) return;

          final controller = await _controller.future;

          await controller.animateCamera(
            g_maps.CameraUpdate.newCameraPosition(
              g_maps.CameraPosition(
                target: g_maps.LatLng(
                  state.point.latLng.latitude,
                  state.point.latLng.longitude,
                ),
                bearing: _heading,
                zoom: _zoom,
              ),
            ),
          );
        },
        buildWhen: (previous, current) => previous != current,
        builder: (_, state) {
          return g_maps.GoogleMap(
            onMapCreated: (controller) async {
              _controller.complete(controller);

              setState(() => _ready = true);

              await controller.animateCamera(
                g_maps.CameraUpdate.newCameraPosition(
                  g_maps.CameraPosition(
                    target: center,
                    zoom: _zoom * 1.7,
                  ),
                ),
              );
            },
            initialCameraPosition: g_maps.CameraPosition(
              target: center,
              bearing: _heading,
              zoom: _zoom,
            ),
            markers: points.map((point) {
              final isSelectedPoint =
                  point.latLng.distanceInKM(state.point.latLng) == 0;

              return g_maps.Marker(
                markerId: g_maps.MarkerId(point.id),
                position: g_maps.LatLng(
                  point.latLng.latitude,
                  point.latLng.longitude,
                ),
                onTap: () {
                  context.read<SelectedPointCubit>().select(point);
                },
                icon: isSelectedPoint ? _selectedPointMarker : _pointMarker,
                zIndex: isSelectedPoint ? 1.0 : 0.0,
              );
            }).toSet(),
            compassEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onTap: (lanLat) {
              context.read<SelectedPointCubit>().clear();
            },
            onCameraMove: (position) {
              _zoom = position.zoom;
              _heading = position.bearing;
            },
          );
        },
      ),
    );
  }
}
