import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PointWidget extends StatelessWidget {
  const PointWidget({
    Key key,
    @required this.point,
    @required this.height,
  }) : super(key: key);

  final Point point;
  final double height;

  @override
  Widget build(BuildContext context) {
    final center = context.select((LocationCubit cubit) => cubit.state.latLng);

    final isExpanded = height > (MediaQuery.of(context).size.height / 2);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: height / 2),
              child: Row(
                children: [
                  Expanded(
                    child: _PhotoWidget(
                      point: point,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8.0),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TagsWidget(tags: {
                              '${point.latLng.toDistance(center)} ק"מ',
                              ...point.tags
                            }),
                            Text(
                              '${point.price.amount.toStringAsFixed(2)} ₪',
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
                    visible: isExpanded,
                    child: CookWidget(cookId: point.cookId),
                  ),
                ],
              ),
            ),
          ],
        ),
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
