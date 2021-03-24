import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:flutter/material.dart';

class CreatePointButton extends StatelessWidget {
  const CreatePointButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'FloatingActionButtonCookPoint',
      tooltip: 'פרסם CookPoint',
      label: const Text('פרסמ/י מאכל'),
      onPressed: () {
        Navigator.of(context).push<void>(CreatePointPage.route());
      },
    );
  }
}
