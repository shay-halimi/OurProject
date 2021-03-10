import 'package:flutter/material.dart';

export 'widgets/widgets.dart';

/// @see https://material.io/develop/web/guides/typography
const baseFontSize = 16.0;

final theme = ThemeData(
  primarySwatch: Colors.blue,
  appBarTheme: appBarTheme,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 6 * baseFontSize,
      fontWeight: FontWeight.w300,
    ),
    headline2: TextStyle(
      fontSize: 3.75 * baseFontSize,
      fontWeight: FontWeight.w300,
    ),
    headline3: TextStyle(
      fontSize: 3 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    headline4: TextStyle(
      fontSize: 2.125 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    headline5: TextStyle(
      fontSize: 1.5 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    headline6: TextStyle(
      fontSize: 1.25 * baseFontSize,
      fontWeight: FontWeight.w500,
    ),
    subtitle1: TextStyle(
      fontSize: 1 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    subtitle2: TextStyle(
      fontSize: 0.875 * baseFontSize,
      fontWeight: FontWeight.w500,
    ),
    bodyText1: TextStyle(
      fontSize: 1 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    bodyText2: TextStyle(
      fontSize: 0.875 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    button: TextStyle(
      fontSize: 0.875 * baseFontSize,
      fontWeight: FontWeight.w500,
    ),
    caption: TextStyle(
      fontSize: 0.75 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    overline: TextStyle(
      fontSize: 0.75 * baseFontSize,
      fontWeight: FontWeight.w500,
    ),
  ),
);

final appBarTheme = const AppBarTheme(
  color: Colors.white,
  iconTheme: IconThemeData(color: Colors.black),
  actionsIconTheme: IconThemeData(color: Colors.black),
  textTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.black,
      fontSize: 6 * baseFontSize,
      fontWeight: FontWeight.w300,
    ),
    headline2: TextStyle(
      color: Colors.black,
      fontSize: 3.75 * baseFontSize,
      fontWeight: FontWeight.w300,
    ),
    headline3: TextStyle(
      color: Colors.black,
      fontSize: 3 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    headline4: TextStyle(
      color: Colors.black,
      fontSize: 2.125 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    headline5: TextStyle(
      color: Colors.black,
      fontSize: 1.5 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    headline6: TextStyle(
      color: Colors.black,
      fontSize: 1.25 * baseFontSize,
      fontWeight: FontWeight.w500,
    ),
    subtitle1: TextStyle(
      color: Colors.black,
      fontSize: 1 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    subtitle2: TextStyle(
      color: Colors.black,
      fontSize: 0.875 * baseFontSize,
      fontWeight: FontWeight.w500,
    ),
    bodyText1: TextStyle(
      color: Colors.black,
      fontSize: 1 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    bodyText2: TextStyle(
      color: Colors.black,
      fontSize: 0.875 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    button: TextStyle(
      color: Colors.black,
      fontSize: 0.875 * baseFontSize,
      fontWeight: FontWeight.w500,
    ),
    caption: TextStyle(
      color: Colors.black,
      fontSize: 0.75 * baseFontSize,
      fontWeight: FontWeight.w400,
    ),
    overline: TextStyle(
      color: Colors.black,
      fontSize: 0.75 * baseFontSize,
      fontWeight: FontWeight.w500,
    ),
  ),
);
