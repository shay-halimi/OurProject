import 'dart:async';
import 'dart:io';

import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
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
  final Completer<google_maps.GoogleMapController> _controller = Completer();

  double _zoom = 12.0;
  double _heading = 0;

  google_maps.BitmapDescriptor _pointMarker =
      google_maps.BitmapDescriptor.defaultMarker;

  google_maps.BitmapDescriptor _selectedPointMarker =
      google_maps.BitmapDescriptor.defaultMarker;

  double get _pixelRatio => widget.pixelRatio;

  @override
  void initState() {
    super.initState();

    var _size = 64;

    if (!Platform.isIOS) {
      if (_pixelRatio >= 1.5) {
        _size = _size * 2;
      } else if (_pixelRatio >= 2.5) {
        _size = _size * 3;
      } else if (_pixelRatio >= 3.5) {
        _size = _size * 4;
      }
    }

    final configuration =
        ImageConfiguration(size: Size(_size.toDouble(), _size.toDouble()));

    google_maps.BitmapDescriptor.fromAssetImage(
            configuration, 'assets/images/mini_marker@$_size.png')
        .then((value) => setState(() => _pointMarker = value));

    google_maps.BitmapDescriptor.fromAssetImage(
            configuration, 'assets/images/marker@$_size.png')
        .then((value) => setState(() => _selectedPointMarker = value));
  }

  @override
  Widget build(BuildContext context) {
    final points = context.select((SearchBloc bloc) => bloc.state.results);
    final location =
        context.select((LocationCubit cubit) => cubit.state.current);

    return BlocConsumer<SelectedPointCubit, SelectedPointState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) async {
        if (state.point.isEmpty || _controller.future == null) return;

        final controller = await _controller.future;

        await controller.animateCamera(
          google_maps.CameraUpdate.newCameraPosition(
            google_maps.CameraPosition(
              target: google_maps.LatLng(
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
        return google_maps.GoogleMap(
          onMapCreated: _controller.complete,
          initialCameraPosition: google_maps.CameraPosition(
            target: google_maps.LatLng(
              location.latitude,
              location.longitude,
            ),
            bearing: _heading,
            zoom: _zoom,
          ),
          markers: points.map((point) {
            final isSelectedPoint =
                point.latLng.distanceInKM(state.point.latLng) == 0;

            return google_maps.Marker(
              markerId: google_maps.MarkerId(point.id),
              position: google_maps.LatLng(
                point.latLng.latitude,
                point.latLng.longitude,
              ),
              onTap: () {
                _hideKeyboard(context);
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
            _hideKeyboard(context);
            context.read<SelectedPointCubit>().clear();
          },
          onCameraMove: (position) {
            _zoom = position.zoom;
            _heading = position.bearing;
          },
        );
      },
    );
  }

  void _hideKeyboard(BuildContext context) => FocusScope.of(context).unfocus();
}
