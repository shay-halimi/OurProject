import 'package:cookpoint/media/media_widget.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:points_repository/points_repository.dart';

class PointWidget extends StatelessWidget {
  const PointWidget({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .push<void>(CreateUpdatePointPage.route(point: point)),
      child: Card(
        child: Column(
          children: [
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: _PhotoWidget(photo: point.media.first),
            ),
            Flexible(
              flex: 2,
              child: _TitleWidget(point: point),
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
    @required this.photo,
  }) : super(key: key);

  final String photo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Hero(
            tag: photo,
            child: MediaWidget(media: photo),
          ),
        ),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  point.title,
                  style: theme.textTheme.headline6,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${point.price.amount.toStringAsFixed(2)} ₪',
                  style: theme.textTheme.headline6
                      .copyWith(fontWeight: FontWeight.w300),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            TagsWidget(tags: point.tags),
            Row(
              children: [
                Text(
                  point.description,
                  overflow: TextOverflow.fade,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
