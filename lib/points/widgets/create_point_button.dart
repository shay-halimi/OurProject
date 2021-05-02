import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';

class CreatePointButton extends StatelessWidget {
  const CreatePointButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'FloatingActionButtonCookPoint',
      tooltip: S.of(context).createPointBtnTooltip,
      label: Text(S.of(context).createPointBtn),
      onPressed: () {
        Navigator.of(context)
            .push<void>(PointFormPage.route(point: Point.empty));
      },
    );
  }
}
