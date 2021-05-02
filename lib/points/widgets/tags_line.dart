import 'package:flutter/material.dart';

class TagsLine extends StatelessWidget {
  const TagsLine({
    Key key,
    @required this.tags,
  }) : super(key: key);

  final Set<String> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return Container();

    var line = tags.first;

    for (var i = 1; i < tags.length; i++) {
      line += ' • ';
      line += tags.elementAt(i);
    }

    return Text(
      line,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
