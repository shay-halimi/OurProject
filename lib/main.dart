import 'package:collaborative_food/map_screen.dart';
import 'package:collaborative_food/tos_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: FutureBuilder<Widget>(
        future: init(context),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          return snapshot.hasData ? snapshot.data : CircularProgressIndicator();
        },
        initialData: CircularProgressIndicator(),
      ),
    );
  }

  Future<Widget> init(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const TOS_KEY = 'tos_version';

    if (prefs.containsKey(TOS_KEY) && prefs.getInt(TOS_KEY) >= 1) {
      return MapScreen();
    }

    return TosScreen(
      callback: () {
        prefs.setInt(TOS_KEY, 1);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MapScreen()),
        );
      },
    );
  }
}
