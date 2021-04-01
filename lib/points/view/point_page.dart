import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PointPage extends StatefulWidget {
  const PointPage({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  static Route route({@required Point point}) {
    return MaterialPageRoute<void>(builder: (_) => PointPage(point: point));
  }

  @override
  _PointPageState createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return CreateUpdatePointPage(point: widget.point);
    }

    final canPerformActions = context.select(
        (PointsBloc bloc) => bloc.state.cookPoints.contains(widget.point));

    return _PointPageView(
      point: widget.point,
      actions: [
        if (canPerformActions) ...[
          _DeleteButton(
            point: widget.point,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'עריכה',
            onPressed: () => setState(() => isEditing = true),
          ),
        ]
      ],
    );
  }
}

class _PointPageView extends StatelessWidget {
  const _PointPageView({
    Key key,
    @required this.point,
    this.actions,
  }) : super(key: key);

  final Point point;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          point.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: actions,
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

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'מחק',
      onPressed: () => showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('האם את/ה בטוח/ה?'),
              content: Text(
                  'האם את/ה בטוח/ה שברצונך למחוק את המאכל ${point.title} ?'),
              actions: [
                TextButton(
                  child: const Text('כן, מחק לצמיתות'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                ElevatedButton(
                  child: const Text('לא'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          }).then((value) {
        if (value) {
          context.read<PointsBloc>().add(PointDeletedEvent(point));
          Navigator.of(context).pop();
        }
      }),
    );
  }
}
