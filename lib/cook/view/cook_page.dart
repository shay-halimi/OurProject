import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CookPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => CookMiddleware(child: CookPage()));
  }

  @override
  Widget build(BuildContext context) {
    final cook = context.select((CookBloc bloc) => bloc.state.cook);

    return Scaffold(
      appBar: AppBar(
        title: const Text('חשבון'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                Navigator.of(context).push<void>(CreateUpdateCookPage.route()),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: PhotoURLWidget(
                photoURL: cook.photoURL,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                ListTile(
                  title: Text(cook.displayName),
                  subtitle: const Text('שם לתצוגה'),
                ),
                ListTile(
                  title: Text(cook.address.name),
                  subtitle: const Text('כתובת'),
                ),
                ListTile(
                  title: Text(humanz.phoneNumber(cook.phoneNumber)),
                  subtitle: const Text('מספר טלפון'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
