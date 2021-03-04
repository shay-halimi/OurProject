import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';

class TagsWidget extends StatelessWidget {
  const TagsWidget({
    Key key,
    @required this.tags,
  }) : super(key: key);

  final Set<String> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return Row();

    final textStyle = theme.textTheme.caption;

    return Row(
      children: [
        Text(tags.first, style: textStyle),
        for (var i = 1; i < tags.length; i++) ...[
          Text(' • ', style: textStyle),
          Text(tags.elementAt(i), style: textStyle),
        ]
      ],
    );
  }
}
