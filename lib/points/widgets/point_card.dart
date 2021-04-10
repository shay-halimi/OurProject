import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PointCard extends StatelessWidget {
  const PointCard({
    Key key,
    @required this.point,
    @required this.height,
    @required this.minHeight,
    @required this.maxHeight,
    this.elevation = 4.0,
  }) : super(key: key);

  final Point point;

  final double height;

  final double minHeight;

  final double maxHeight;

  final double elevation;

  @override
  Widget build(BuildContext context) {
    final center =
        context.select((LocationCubit cubit) => cubit.state.toLatLng());

    return Card(
      elevation: elevation,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: _mediaHeight),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: MediaWidget(url: point.media.first),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TagsLine(tags: {
                              humanz.distance(point.latLng, center),
                              ...point.tags,
                            }),
                            Text(
                              humanz.money(point.price),
                              style: theme.textTheme.headline6
                                  .copyWith(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                point.title,
                                style: theme.textTheme.headline6,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        point.description,
                        style: theme.textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: _isCookVisible,
            child: CookWidget(cookId: point.cookId),
          ),
        ],
      ),
    );
  }

  double get _mediaHeight {
    final min = minHeight - (elevation * 2);
    final max = height * 0.6;

    return height != minHeight && max > min ? max : min;
  }

  bool get _isCookVisible =>
      height > (minHeight + ((maxHeight - minHeight) * 0.6));
}
