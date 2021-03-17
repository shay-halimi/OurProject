import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/media/media_widget.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _photos(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
                      Column(
                        children: [
                          Text(
                            '${point.price.amount.toStringAsFixed(2)} ₪',
                            style: theme.textTheme.headline5
                                .copyWith(fontWeight: FontWeight.w300),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                          ),
                          TagsWidget(tags: point.tags),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    ),
                  ),
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
      bottomNavigationBar: CookerWidget(cookerId: point.cookerId),
    );
  }

  Widget _photos(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Hero(
        tag: point.media.first,
        child: MediaWidget(media: point.media.first),
      ),
    );
  }
}
