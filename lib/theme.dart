import 'package:flutter/material.dart';

final theme = ThemeData(
  primarySwatch: MaterialColor(
    0xFF2F3D58,
    <int, Color>{
      50: Color(0xFFECEDEF),
      100: Color(0xFFC6CAD1),
      200: Color(0xFFA0A6B3),
      300: Color(0xFF7A8394),
      400: Color(0xFF546076),
      500: Color(0xFF2F3D58),
      600: Color(0xFF273249),
      700: Color(0xFF1E2739),
      800: Color(0xFF161C28),
      900: Color(0xFF050608),
    },
  ),

  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0),
    headline6: TextStyle(fontSize: 36.0),
    bodyText2: TextStyle(fontSize: 14.0),
  ),
);
