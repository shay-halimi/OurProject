import 'package:collaborative_food/map_screen.dart';
import 'package:collaborative_food/tos_screen.dart';
// import 'package:collaborative_food/tos_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TosScreen(),
    );
  }
}