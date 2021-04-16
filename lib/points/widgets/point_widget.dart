import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';

class PointWidget extends StatelessWidget {
  const PointWidget({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 1 / 3;

    return InkWell(
      child: Card(
        key: ValueKey(point.id),
        child: Column(
          children: [
            MediaWidget(
              url: point.media.first,
              maxHeight: maxHeight,
            ),
            ListTile(
              isThreeLine: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        point.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      point.isTrashed ? 'לא זמין' : 'זמין',
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  point.description,
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context).push<void>(
        PointPage.route(point: point),
      ),
    );
  }
}
