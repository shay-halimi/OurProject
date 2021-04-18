import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/widgets/circle_button.dart';
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
  }) : super(key: key);

  final Point point;

  final double height;

  final double minHeight;

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final center =
        context.select((LocationCubit cubit) => cubit.state.toLatLng());

    final cook = context.select((CookBloc bloc) => bloc.state.cook);

    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: _mediaMaxHeight),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: MediaWidget(
                                url: point.media.firstWhere(
                                  (_) => true,
                                  orElse: () =>
                                      'https://firebasestorage.googleapis.com/v0/b/cookpoint-e16ce.appspot.com/o/gallery%2Fa0bd5840-8b9a-11eb-83f6-55a40a23d4f8?alt=media&token=a2ebfecd-bad0-44fd-959d-1b01acf241db',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if ([
                              /// User
                              point.cookId,

                              /// Shaked
                              'Ur3Y8j47SeP9Oj6ymxatELRjlxU2',
                              'SPMnvofiFJgmOwC7ufmjWDH58hW2',

                              /// Matan
                              '5ZjdQNuRuEUggKUUAf9qSJejMwY2',
                            ].contains(cook.id))
                              CircleButton(
                                child: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).push<void>(
                                      PointPage.route(point: point));
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Row(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TagsLine(tags: {
                              humanz.distance(point.latLng, center),
                              ...point.tags,
                            }),
                            Text(
                              humanz.money(point.price),
                              style: textTheme.headline6
                                  .copyWith(fontWeight: FontWeight.w300),
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
                        style: textTheme.bodyText2,
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

  double get _mediaMaxHeight {
    final padding = 8.0;
    final min = minHeight;
    final max = height * 0.6;

    return (height != minHeight && max > min ? max : min) - padding;
  }

  /// @TODO<Matan> CookWidgetCubit request the cook from the server
  /// @TODO<Matan> Each time the height is changed.
  /// @TODO<Matan> This is only an hot fix, check git for the original logic.
  bool get _isCookVisible => height == maxHeight;
}
