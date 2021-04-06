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
    final center =
        context.select((LocationCubit cubit) => cubit.state.toLatLng());

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: MediaWidget(
              media: point.media.first,
              maxHeight: (height * 1 / 3),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
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
                    ],
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
                CookWidget(cookId: point.cookId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
