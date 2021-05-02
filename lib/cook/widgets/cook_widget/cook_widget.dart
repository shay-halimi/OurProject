import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/imagez.dart';
import 'package:flutter/material.dart';

export 'cubit/cubit.dart';

class CookWidget extends StatelessWidget {
  const CookWidget({
    Key key,
    @required this.cook,
  }) : super(key: key);

  final Cook cook;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundImage: cook.isEmpty ? null : imagez.url(cook.photoURL),
          ),
          title: Text(cook.displayName),
        ),
        if (cook.isEmpty) const LinearProgressIndicator(),
      ],
    );
  }
}
