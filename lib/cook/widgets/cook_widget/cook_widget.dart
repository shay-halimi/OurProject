import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as map_launcher;
import 'package:map_launcher/map_launcher.dart';

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
      )..load(cookId),
      child: BlocBuilder<CookWidgetCubit, CookWidgetState>(
        buildWhen: (previous, current) => previous != current,
        builder: (_, state) {
          if (state is CookWidgetLoaded) {
            return CookWidgetView(
              cook: state.cook,
            );
          }

          return Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              const ListTile(
                visualDensity: VisualDensity.compact,
                leading: CircleAvatar(),
                title: Text(''),
                subtitle: Text(''),
                trailing: Icon(LineAwesomeIcons.vertical_ellipsis),
              ),
              const LinearProgressIndicator(),
            ],
          );
        },
      ),
    );
  }
}

class CookWidgetView extends StatelessWidget {
  const CookWidgetView({
    Key key,
    @required this.cook,
  }) : super(key: key);

  final Cook cook;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(cook.photoURL),
      ),
      title: Text(cook.displayName),
      subtitle: Text(cook.address.name),
      onTap: () => _onTap(context),
      trailing: const Icon(LineAwesomeIcons.vertical_ellipsis),
    );
  }

  Future<void> _onTap(BuildContext context) async {
    return showModalBottomSheet<map_launcher.AvailableMap>(
      context: context,
      builder: (BuildContext context) {
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

  static const iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AvailableMap>>(
      future: map_launcher.MapLauncher.installedMaps,
      builder: (_, snapshot) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: snapshot.hasData
                  ? Wrap(
                      children: [
                        _phone(context),
                        _whatsapp(context),
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
      leading: SvgPicture.asset(
        map.icon,
        height: iconSize,
        width: iconSize,
      ),
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

  Widget _whatsapp(BuildContext context) {
    return ListTile(
      onTap: () async {
        await launcher
            .whatsapp(cook.phoneNumber)
            .then((_) => Navigator.of(context).pop());
      },
      title: const Text('WhatsApp'),
      leading: const Icon(
        LineAwesomeIcons.what_s_app,
        size: iconSize,
      ),
    );
  }

  Widget _phone(BuildContext context) {
    return ListTile(
      onTap: () async {
        await launcher
            .call(cook.phoneNumber)
            .then((_) => Navigator.of(context).pop());
      },
      title: Text(humanz.phoneNumber(cook.phoneNumber)),
      leading: const Icon(
        LineAwesomeIcons.phone,
        size: iconSize,
      ),
    );
  }
}
