import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PointCard extends StatelessWidget {
  const PointCard({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    final textTheme = Theme.of(context).textTheme;

    final isEditable = [
      point.cookId,
      'Ur3Y8j47SeP9Oj6ymxatELRjlxU2',
      'SPMnvofiFJgmOwC7ufmjWDH58hW2',
      '5ZjdQNuRuEUggKUUAf9qSJejMwY2',
    ].contains(user.id);

    final url = point.media.firstWhere(
      (_) => true,
      orElse: () =>
          'https://firebasestorage.googleapis.com/v0/b/cookpoint-e16ce.appspot.com/o/gallery%2Fa0bd5840-8b9a-11eb-83f6-55a40a23d4f8?alt=media&token=a2ebfecd-bad0-44fd-959d-1b01acf241db',
    );

    return Card(
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Hero(
                          tag: url,
                          child: Image(
                            image: CachedNetworkImageProvider(url),
                            fit: BoxFit.cover,
                            loadingBuilder: _loadingBuilder,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        point.title,
                        style: textTheme.headline6,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        point.description,
                        style: textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TagsLine(
                        tags: point.tags,
                      ),
                    ),
                    if (point.price.amount > 0.00)
                      Text(
                        humanz.money(point.price),
                        style: textTheme.headline6
                            .copyWith(fontWeight: FontWeight.w300),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (isEditable)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleButton(
                child: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .push<void>(PointPage.route(point: point));
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _loadingBuilder(
    BuildContext context,
    Widget child,
    ImageChunkEvent loadingProgress,
  ) {
    return loadingProgress == null ? child : Container();
  }
}
