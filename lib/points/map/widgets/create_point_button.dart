import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/points/points.dart';
import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePointButton extends StatefulWidget {
  const CreatePointButton({
    Key key,
  }) : super(key: key);

  @override
  _CreatePointButtonState createState() => _CreatePointButtonState();
}

class _CreatePointButtonState extends State<CreatePointButton> {
  bool _isDoughing = false;

  @override
  Widget build(BuildContext context) {
    return PressableDough(
      child: FloatingActionButton(
        heroTag: 'FloatingActionButtonCookPoint',
        tooltip: 'פרסם CookPoint',
        child: _isDoughing ? const Icon(Icons.refresh) : const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push<void>(CreatePointPage.route());
        },
      ),
      onReleased: (details) {
        if (details.delta.distance > 200) {
          return context.read<LocationCubit>().locate();
        } else {
          setState(() => _isDoughing = false);
        }
      },
      onStart: () => setState(() => _isDoughing = true),
    );
  }
}
