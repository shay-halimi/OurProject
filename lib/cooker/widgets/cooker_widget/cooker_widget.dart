import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

export 'cubit/cubit.dart';

class CookerWidget extends StatelessWidget {
  const CookerWidget({
    Key key,
    @required this.cookerId,
  }) : super(key: key);

  final String cookerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CookerWidgetCubit(
        cookersRepository: context.read<CookersRepository>(),
      )..load(cookerId),
      child: BlocBuilder<CookerWidgetCubit, CookerWidgetState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is CookerWidgetLoaded) {
            return CookerWidgetView(
              cooker: state.cooker,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class CookerWidgetView extends StatelessWidget {
  const CookerWidgetView({
    Key key,
    @required this.cooker,
  }) : super(key: key);

  final Cooker cooker;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(cooker.photoURL),
      ),
      title: Text(cooker.displayName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.whatsapp),
            onPressed: () async =>
                await launcher.web('https://wa.me/${cooker.phoneNumber}'),
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () async => await launcher.dial(cooker.phoneNumber),
          ),
          IconButton(
            icon: const Icon(Icons.directions),
            onPressed: () async => await launcher.web(
                'geo:${cooker.address.latitude},${cooker.address.longitude}?q=${cooker.address.name}'),
          ),
        ],
      ),
      onTap: () async => await launcher.dial(cooker.phoneNumber),
    );
  }
}
