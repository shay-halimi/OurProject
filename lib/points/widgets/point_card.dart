import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/imagez.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PointCard extends StatelessWidget {
  const PointCard({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  static const double aspectRatio = 4 / 3;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Image(
                      image: imagez.url(point.media.first),
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, loadingProgress) {
                        return loadingProgress == null
                            ? child
                            : const LinearProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            ),
            _Footer(
              point: point,
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    final center =
        context.select((LocationCubit cubit) => cubit.state.toLatLng());

    return Container(
      color: Colors.white.withOpacity(0.92),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          ListTile(
              title: Text(point.title),
              subtitle: TagsLine(
                tags: {
                  S.of(context).kmFromYou(
                        humanz.distance(point.latLng, center),
                      ),
                  ...point.tags,
                },
              ),
              trailing:
                  point.price.isEmpty ? null : Text(humanz.money(point.price))),
        ],
      ),
    );
  }
}
