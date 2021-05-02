import 'package:flutter/material.dart';

export 'widgets/widgets.dart';

const _borderRadius = BorderRadius.all(Radius.circular(33.0));

const _primaryColor = Color(0xFFDD5534);

final theme = ThemeData(
  primaryColor: _primaryColor,
  buttonTheme: const ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: _borderRadius,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
          borderRadius: _borderRadius,
        ),
      ),
    ),
  ),
);
