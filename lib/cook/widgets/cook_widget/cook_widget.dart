import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/launcher.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;

export 'cubit/cubit.dart';

class CookWidget extends StatelessWidget {
  const CookWidget({
    Key key,
    @required this.cookId,
  }) : super(key: key);

  final String cookId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CookWidgetCubit(
        cooksRepository: context.read<CooksRepository>(),
      )..request(cookId),
      child: BlocBuilder<CookWidgetCubit, CookWidgetState>(
        buildWhen: (previous, current) => previous != current,
        builder: (_, state) {
          final cook = state is CookWidgetLoaded ? state.cook : Cook.empty;

          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              ListTile(
                visualDensity: VisualDensity.compact,
                leading: CircleAvatar(
                  backgroundImage: cook.isEmpty
                      ? null
                      : CachedNetworkImageProvider(cook.photoURL),
                ),
                title: Text(cook.displayName),
                subtitle: Text(cook.address.name),
                onTap: cook.isEmpty ? null : () => _onTap(context, cook),
                trailing: const Icon(LineAwesomeIcons.phone),
              ),
              if (cook.isEmpty) const LinearProgressIndicator(),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onTap(BuildContext context, Cook cook) async {
    await FirebaseAnalytics().logEvent(
      name: 'add_to_cart',
      parameters: <String, dynamic>{
        'cook': cook.id,
      },
    );

    return showModalBottomSheet<map_launcher.AvailableMap>(
      context: context,
      routeSettings: RouteSettings(name: '/cooks/${cook.id}'),
      builder: (_) {
        return _ActionsDialog(cook: cook);
      },
    );
  }
}

class _ActionsDialog extends StatelessWidget {
  const _ActionsDialog({
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
                        _phone(context),
                        _whatsApp(context),
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
      title: Text(map.mapName),
      leading: Icon(map.iconData),
      onTap: () async {
        await FirebaseAnalytics().logEvent(
          name: 'purchase',
          parameters: <String, dynamic>{
            'cook': cook.id,
          },
        );

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

  Widget _whatsApp(BuildContext context) {
    return ListTile(
      onTap: () async {
        await FirebaseAnalytics().logEvent(
          name: 'add_payment_info',
          parameters: <String, dynamic>{
            'cook': cook.id,
          },
        );

        await launcher
            .whatsApp(cook.phoneNumber)
            .then((_) => Navigator.of(context).pop());
      },
      title: const Text('WhatsApp'),
      leading: const Icon(LineAwesomeIcons.what_s_app),
    );
  }

  Widget _phone(BuildContext context) {
    return ListTile(
      onTap: () async {
        await FirebaseAnalytics().logEvent(
          name: 'add_payment_info',
          parameters: <String, dynamic>{
            'cook': cook.id,
          },
        );

        await launcher
            .call(cook.phoneNumber)
            .then((_) => Navigator.of(context).pop());
      },
      title: Text(humanz.phoneNumber(cook.phoneNumber)),
      leading: const Icon(LineAwesomeIcons.phone),
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
