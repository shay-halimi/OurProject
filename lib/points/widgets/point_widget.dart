import 'package:cookpoint/media/media_widget.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:points_repository/points_repository.dart';

class PointWidget extends StatelessWidget {
  const PointWidget({
    Key key,
    @required this.point,
    this.onTap,
    this.height,
  }) : super(key: key);

  final Point point;
  final GestureTapCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final priceTextStyle =
        theme.textTheme.headline6.copyWith(fontWeight: FontWeight.w300);

    return Card(
      child: Container(
        height: height,
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              _PhotoWidget(photo: point.media.first),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Opacity(
                  opacity: 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TagsWidget(tags: point.tags),
                          Text(
                            '${point.price.amount.toStringAsFixed(2)} ₪',
                            style: priceTextStyle,
                          ),
                        ],
                      ),
                      _TitleWidget(point: point),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
            child: AspectRatio(
              child: MediaWidget(media: photo),
              aspectRatio: 1 / 1,
            ),
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
    return Row(
      children: [
        Expanded(
          child: Text(
            point.title,
            style: theme.textTheme.headline6,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
