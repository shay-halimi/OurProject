import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CookPage extends StatelessWidget {
  const CookPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/cooks/me'),
      builder: (_) => const CookMiddleware(
        child: CookPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cook = context.select((CookBloc bloc) => bloc.state.cook);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).accountPageTitle),
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
                  subtitle: Text(S.of(context).displayName),
                ),
                ListTile(
                  title: Text(cook.address.name),
                  subtitle: Text(S.of(context).address),
                ),
                ListTile(
                  title: Text(humanz.phoneNumber(cook.phoneNumber)),
                  subtitle: Text(S.of(context).phoneNumber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
