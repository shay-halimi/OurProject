import 'dart:async';
import 'dart:math';

import 'package:cookpoint/map/map.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key key, @required this.points}) : super(key: key);

  final List<Point> points;

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
          markers: widget.points
              .map((point) => google_maps.Marker(
                    markerId: google_maps.MarkerId(point.id),
                    position: google_maps.LatLng(
                      point.latitude,
                      point.longitude,
                    ),
                    onTap: () {
                      /// todo select a point on points seg.,
                    },
                    icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                      point.relevant
                          ? google_maps.BitmapDescriptor.hueGreen
                          : google_maps.BitmapDescriptor.hueRed,
                    ),
                  ))
              .toSet(),
          compassEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onTap: (lanLat) => context.read<PointsBloc>().add(
                PointCreatedEvent(
                  Point.empty.copyWith(
                    relevant: Random().nextBool(),
                    latitude: lanLat.latitude,
                    longitude: lanLat.longitude,
                    title: 'הדאל של גל ${Random().nextInt(9999)}',
                    description: '''דאל טרי עשוי בעבודת יד יום יום מעדשים כתומות

תערובת תבלינים ,גזר , בצל

מנה 20 ש''ח
אורז 10 ש''ח
5 מנות עם אורז - 80 ש''ח

הזמנות עד יום חמישי ב18:00
ניתן לפנות בוואצאפ או בטלפון 
''',
                    price: Money.empty.copyWith(amount: 29.90),
                    media: {
                      'https://veg.co.il/wp-content/uploads/red-lentil-dal-966x587.jpg'
                    },
                    tags: {'טבעוני', 'צמחוני'},
                  ),
                ),
              ),
          onCameraMove: (pos) => zoom = pos.zoom,
        );
      },
    );
  }
}
