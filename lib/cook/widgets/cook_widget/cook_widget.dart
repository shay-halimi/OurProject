import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/launcher.dart';
import 'package:cooks_repository/cooks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        builder: (context, state) {
          if (state is CookWidgetLoaded) {
            return CookWidgetView(
              cook: state.cook,
            );
          }

          return const LinearProgressIndicator();
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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.whatsapp),
            onPressed: () async => await launcher.whatsapp(cook.phoneNumber),
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () async => await launcher.call(cook.phoneNumber),
          ),
          IconButton(
            icon: const Icon(Icons.directions),
            onPressed: () async => await launcher.directions(cook.address),
          ),
        ],
      ),
    );
  }
}
