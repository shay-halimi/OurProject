import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/media/media_widget.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

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
    return _PointPageView(point: point);
  }
}

class _PointPageView extends StatelessWidget {
  const _PointPageView({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    final cooker = context.select((CookerBloc bloc) => bloc.state.cooker);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          point.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (point.cookerId == cooker.id)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'עריכה',
              onPressed: () => Navigator.of(context).push<void>(
                CreateUpdatePointPage.route(point: point),
              ),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
      bottomNavigationBar: SafeArea(
        child: CookerWidget(
          cookerId: point.cookerId,
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
