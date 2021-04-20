import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePointButton extends StatelessWidget {
  const CreatePointButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'FloatingActionButtonCookPoint',
      tooltip: AppLocalizations.of(context).createPointBtnTooltip,
      label: Text(AppLocalizations.of(context).createPointBtn),
      onPressed: () {
        Navigator.of(context).push<void>(PointPage.route(point: Point.empty));
      },
    );
  }
}
