import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/imagez.dart';
import 'package:cookpoint/launcher.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;
import 'package:provider/provider.dart';

class PointPage extends StatelessWidget {
  const PointPage({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  static Route route({
    @required Point point,
  }) {
    return MaterialPageRoute<void>(
      settings: RouteSettings(name: '/points/${point.id}'),
      builder: (_) => PointPage(
        point: point,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final center =
        context.select((LocationCubit location) => location.state.toLatLng());

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              BlocProvider(
                create: (_) => CookWidgetCubit(
                  cookId: point.cookId,
                  cooksRepository: context.read<CooksRepository>(),
                ),
                child: BlocBuilder<CookWidgetCubit, CookWidgetState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (_, state) {
                    final cook =
                        state is CookWidgetLoaded ? state.cook : Cook.empty;

                    return Card(
                      margin: EdgeInsets.zero,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.8,
                                  ),
                                  child: Image(
                                    image: imagez.url(point.media.first),
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (_, child, loadingProgress) {
                                      return loadingProgress == null
                                          ? child
                                          : const LinearProgressIndicator();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            title: Text(
                              point.title,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            subtitle: TagsLine(
                              tags: {
                                S.of(context).kmFromYou(
                                    humanz.distance(point.latLng, center)),
                                ...point.tags,
                              },
                            ),
                            trailing: point.price.isEmpty
                                ? null
                                : Text(
                                    humanz.money(point.price),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                CookWidget(
                                  cook: cook,
                                ),
                                if (point.description.isNotEmpty)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(point.description),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await FirebaseAnalytics().logEvent(
                                      name: 'lead',
                                      parameters: <String, dynamic>{
                                        'cook': cook.id,
                                        'point': point.id,
                                        'value': point.price.amount,
                                        'phone': cook.phoneNumber,
                                        'type': 'whatsApp',
                                      },
                                    );
                                    return launcher.whatsApp(cook.phoneNumber);
                                  },
                                  label: Text(S.of(context).whatsAppBtn),
                                  icon: const Icon(LineAwesomeIcons.what_s_app),
                                ),
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await FirebaseAnalytics().logEvent(
                                      name: 'lead',
                                      parameters: <String, dynamic>{
                                        'cook': cook.id,
                                        'point': point.id,
                                        'value': point.price.amount,
                                        'phone': cook.phoneNumber,
                                        'type': 'phone',
                                      },
                                    );
                                    return launcher.call(cook.phoneNumber);
                                  },
                                  label: Text(S.of(context).phoneBtn),
                                  icon: const Icon(LineAwesomeIcons.phone),
                                ),
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await FirebaseAnalytics().logEvent(
                                      name: 'lead',
                                      parameters: <String, dynamic>{
                                        'cook': cook.id,
                                        'point': point.id,
                                        'value': point.price.amount,
                                        'phone': cook.phoneNumber,
                                        'type': 'directions',
                                      },
                                    );
                                    return showModalBottomSheet<
                                        map_launcher.AvailableMap>(
                                      context: context,
                                      builder: (_) {
                                        return _DirectionsDialog(cook: cook);
                                      },
                                    );
                                  },
                                  label: Text(S.of(context).directionsBtn),
                                  icon: const Icon(LineAwesomeIcons.directions),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _Suggestions(
                point: point,
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                const SafeArea(
                  child: CloseButton(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    final suggestions = context
        .select((PointsBloc bloc) => bloc.state.nearbyPoints)
        .where((p) => p.cookId == point.cookId)
        .toList()
          ..remove(point);

    return Column(
      children: [
        for (var suggestion in suggestions)
          InkWell(
            onTap: () => Navigator.of(context).pushReplacement<void, void>(
              PointPage.route(
                point: suggestion,
              ),
            ),
            child: PointCard(
              point: suggestion,
            ),
          ),
      ],
    );
  }
}

class _DirectionsDialog extends StatelessWidget {
  const _DirectionsDialog({
    Key key,
    @required this.cook,
  }) : super(key: key);

  final Cook cook;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<map_launcher.AvailableMap>>(
      future: map_launcher.MapLauncher.installedMaps,
      builder: (_, snapshot) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: snapshot.hasData
                  ? Wrap(
                      children: [
                        for (var map in snapshot.data) _map(context, map),
                      ],
                    )
                  : const Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _map(BuildContext context, map_launcher.AvailableMap map) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Text(map.mapName),
      leading: Icon(map.iconData),
      onTap: () async {
        await map
            .showMarker(
              coords: map_launcher.Coords(
                cook.address.latitude,
                cook.address.longitude,
              ),
              title: cook.address.name,
            )
            .then((value) => Navigator.of(context).pop());
      },
    );
  }
}

extension _XMap on map_launcher.AvailableMap {
  IconData get iconData {
    switch (mapType) {
      case map_launcher.MapType.waze:
        return LineAwesomeIcons.waze;

      default:
        return LineAwesomeIcons.directions;
    }
  }
}
