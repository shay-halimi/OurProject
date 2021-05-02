import 'dart:async';
import 'dart:io';

import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/search/search.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as g_maps;
import 'package:provider/provider.dart';

class PointsMapWidget extends StatefulWidget {
  const PointsMapWidget({
    Key key,
    @required this.pixelRatio,
  }) : super(key: key);

  final double pixelRatio;

  @override
  _PointsMapWidgetState createState() => _PointsMapWidgetState();
}

class _PointsMapWidgetState extends State<PointsMapWidget> {
  static const double defaultZoom = 13.0;

  final Completer<g_maps.GoogleMapController> _controller = Completer();

  double _zoom = defaultZoom;

  double _heading = 0;

  LatLng _center;

  g_maps.BitmapDescriptor _marker = g_maps.BitmapDescriptor.defaultMarker;

  g_maps.BitmapDescriptor _selectedMarker =
      g_maps.BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();

    g_maps.BitmapDescriptor.fromAssetImage(const ImageConfiguration(),
            'assets/images/mini_marker_$_markerSize.png')
        .then((value) {
      if (!mounted) return;

      setState(() => _marker = value);
    });

    g_maps.BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/marker_$_markerSize.png')
        .then((value) {
      if (!mounted) return;

      setState(() => _selectedMarker = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final location =
        context.select((LocationCubit cubit) => cubit.state.toLatLng());

    return Opacity(
      opacity: _controller.future == null ? 0 : 1,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          BlocConsumer<SearchBloc, SearchState>(
            listenWhen: (previous, current) =>
                previous.selected != current.selected,
            listener: (_, state) async {
              if (state.selected.isNotEmpty) {
                await _focus(state.selected.latLng, _zoom);
              }
            },
            buildWhen: (previous, current) => previous != current,
            builder: (_, state) {
              return Listener(
                onPointerDown: (_) => context
                    .read<SearchBloc>()
                    .add(const SearchResultSelected(Point.empty)),
                child: g_maps.GoogleMap(
                  onMapCreated: (controller) async {
                    if (!mounted) return;

                    context
                        .read<PointsBloc>()
                        .add(PointsNearbyRequestedEvent(_center ?? location));

                    setState(() {
                      controller.setMapStyle(_mapStyle);
                      _controller.complete(controller);
                    });

                    final focus = state.selected.isEmpty
                        ? location
                        : state.selected.latLng;

                    await _focus(focus, _zoom);
                  },
                  initialCameraPosition: g_maps.CameraPosition(
                    target: location.toGMapsLatLng(),
                    bearing: _heading,
                    zoom: _zoom,
                  ),
                  markers: state.results.map((point) {
                    return g_maps.Marker(
                      markerId: g_maps.MarkerId(point.cookId),
                      position: point.latLng.toGMapsLatLng(),
                      onTap: () {
                        context
                            .read<SearchBloc>()
                            .add(SearchResultSelected(point));
                      },
                      icon: point == state.selected ? _selectedMarker : _marker,
                      zIndex: point == state.selected ? 1.0 : 0.0,
                    );
                  }).toSet(),
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  onCameraMove: (position) {
                    if (!mounted) return;
                    _zoom = position.zoom;
                    _heading = position.bearing;
                    _center = position.toLatLng();
                  },
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<PointsBloc>()
                          .add(PointsNearbyRequestedEvent(_center ?? location)),
                      icon: const Icon(Icons.refresh),
                      label: Text(S.of(context).searchThisAreaBtn),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      PressableDough(
                        child: BlocBuilder<LocationCubit, LocationState>(
                          buildWhen: (previous, current) =>
                              previous.status != current.status,
                          builder: (_, state) {
                            final isError =
                                state.status == LocationStatus.error;

                            return CircleButton(
                              child: isError
                                  ? const Icon(
                                      Icons.location_disabled,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.my_location),
                              onPressed: () {
                                if (isError) {
                                  context.read<LocationCubit>().locate(true);
                                }
                                return _focus(state.toLatLng(), defaultZoom);
                              },
                            );
                          },
                        ),
                        onReleased: (details) {
                          if (details.delta.distance >= 200) {
                            return context.read<LocationCubit>().locate();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _focus(LatLng target, double zoom) async {
    if (_controller.future == null) return;

    final controller = await _controller.future;

    await controller.animateCamera(
      g_maps.CameraUpdate.newCameraPosition(
        g_maps.CameraPosition(
          target: g_maps.LatLng(
            target.latitude,
            target.longitude,
          ),
          bearing: _heading,
          zoom: zoom,
        ),
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

  String get _mapStyle => '''[
{
  "featureType": "administrative",
  "elementType": "geometry",
  "stylers": [
    {
      "visibility": "off"
    }
  ]
},
{
  "featureType": "poi",
  "stylers": [
    {
      "visibility": "off"
    }
  ]
},
{
  "featureType": "road",
  "elementType": "labels.icon",
  "stylers": [
    {
      "visibility": "off"
    }
  ]
},
{
  "featureType": "transit",
  "stylers": [
    {
      "visibility": "off"
    }
  ]
}
]''';
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
