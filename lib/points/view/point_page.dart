import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/launcher.dart';
import 'package:cookpoint/media/media_widget.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:points_repository/points_repository.dart';

class PointPage extends StatelessWidget {
  const PointPage({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  static Route route({@required Point point}) {
    return MaterialPageRoute<void>(builder: (_) => PointPage(point: point));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CookerWidgetCubit(
        cookersRepository: context.read<CookersRepository>(),
      )..load(point.cookerId),
      child: BlocBuilder<CookerWidgetCubit, CookerWidgetState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is CookerWidgetLoaded) {
            return _PointView(
              point: point,
              cooker: state.cooker,
            );
          }

          return const LinearProgressIndicator();
        },
      ),
    );
  }
}

class _PointView extends StatelessWidget {
  const _PointView({
    Key key,
    @required this.point,
    @required this.cooker,
  }) : super(key: key);

  final Point point;
  final Cooker cooker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(cooker.photoURL),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cooker.displayName),
                  Text(
                    cooker.address.name,
                    style: theme.textTheme.caption,
                  ),
                ],
              ),
              actions: [
                const CloseButton(),
              ],
            ),
            _PhotoWidget(point: point),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TagsWidget(tags: point.tags),
                      Text(
                        '${point.price.amount.toStringAsFixed(2)} ₪',
                        style: theme.textTheme.headline5
                            .copyWith(fontWeight: FontWeight.w300),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          point.title,
                          style: theme.textTheme.headline5,
                        ),
                      ),
                    ],
                  ),
                  ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 16)),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          point.description,
                          style: theme.textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                'geo:${cooker.address.latitude},${cooker.address.longitude}'
                '&q=${cooker.address.name}'),
          ),
        ],
      ),
    );
  }
}

class _PhotoWidget extends StatelessWidget {
  const _PhotoWidget({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Hero(
        tag: point.media.first,
        child: MediaWidget(media: point.media.first),
      ),
    );
  }
}
