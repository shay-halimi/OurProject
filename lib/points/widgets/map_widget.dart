import 'dart:async';
import 'dart:io';

import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
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

  bool _ready = false;

  double _zoom = 8.0;

  double _heading = 0;

  LatLng _center = LatLng.empty;

  g_maps.BitmapDescriptor _pointMarker = g_maps.BitmapDescriptor.defaultMarker;

  g_maps.BitmapDescriptor _selectedPointMarker =
      g_maps.BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();

    g_maps.BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
            'assets/images/mini_marker_$_markerSize.png')
        .then((value) => setState(() => _pointMarker = value));

    g_maps.BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/marker_$_markerSize.png')
        .then((value) => setState(() => _selectedPointMarker = value));
  }

  @override
  Widget build(BuildContext context) {
    final points = context.select((SearchBloc bloc) => bloc.state.results);

    final target = points.isEmpty
        ? context.select((LocationCubit cubit) => cubit.state).toLatLng()
        : points.first.latLng;

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
                    target: target.toGMapsLatLng(),
                    zoom: _zoom * 1.7,
                  ),
                ),
              );
            },
            initialCameraPosition: g_maps.CameraPosition(
              target: target.toGMapsLatLng(),
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
              setState(() {
                _zoom = position.zoom;
                _heading = position.bearing;
                _center = position.toLatLng();
              });
            },
            onCameraIdle: () {
              final radiusInKM = 100.0;

              final refresh = points
                  .map((point) => point.latLng)
                  .where((latLng) => latLng.distanceInKM(_center) < radiusInKM)
                  .isEmpty;

              if (refresh) {
                context
                    .read<PointsBloc>()
                    .add(PointsNearbyRequestedEvent(_center, radiusInKM));
              }
            },
          );
        },
      ),
    );
  }

  num get _pixelRatio => widget.pixelRatio;

  num get _markerSize {
    var _size = 64;

    bool isIOS;
    try {
      isIOS = Platform.isIOS;
    } catch (e) {
      isIOS = false;
    }

    if (!isIOS) {
      if (_pixelRatio >= 1.5) {
        return _size * 2;
      } else if (_pixelRatio >= 2.5) {
        return _size * 3;
      } else if (_pixelRatio >= 3.5) {
        return _size * 4;
      }
    }

    return _size;
  }
}

extension _XLocationState on LocationState {
  LatLng toLatLng() {
    return LatLng(
      latitude: latitude,
      longitude: longitude,
    );
  }
}

extension _XGMapsCameraPosition on g_maps.CameraPosition {
  LatLng toLatLng() {
    return LatLng(
      latitude: target.latitude,
      longitude: target.longitude,
    );
  }
}

extension _XLatLng on LatLng {
  g_maps.LatLng toGMapsLatLng() {
    return g_maps.LatLng(
      latitude,
      longitude,
    );
  }
}
