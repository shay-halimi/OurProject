import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/launcher.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    return ListView(
      padding: const EdgeInsets.all(32.0),
      shrinkWrap: true,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(32.0),
          child: AppCover(),
        ),
        const Divider(),
        ListTile(
          key: const Key('AppDrawer_CookPage_ListTile'),
          leading: const Icon(Icons.account_circle),
          title: const Text('המטבח שלי'),
          onTap: () => Navigator.of(context).push<void>(
            CookPage.route(),
          ),
          onLongPress: () => context
              .read<AuthenticationBloc>()
              .add(AuthenticationLogoutRequested()),
        ),
        if (user.isNotEmpty) ...[
          ListTile(
            key: const Key('AppDrawer_CookPointsPage_ListTile'),
            leading: const Icon(Icons.restaurant),
            title: const Text('התפריט שלי'),
            onTap: () => Navigator.of(context).push<void>(
              PointsPage.route(),
            ),
          ),
        ],
        const Divider(),
        ListTile(
          dense: true,
          key: const Key('AppDrawer_AboutUsPage_ListTile'),
          leading: const Icon(Icons.info),
          title: const Text('אודות'),
          onTap: () => null,
        ),
        ListTile(
          dense: true,
          key: const Key('AppDrawer_EmailUs_ListTile'),
          leading: const Icon(Icons.support_agent),
          title: const Text('צרו קשר'),
          onTap: () async => await launcher.email('cookpointapp@gmail.com'),
        ),
        ListTile(
          dense: true,
          key: const Key('AppDrawer_TOSPage_ListTile'),
          leading: const Icon(Icons.description),
          title: const Text('תנאים ומדיניות פרטיות'),
          onTap: () => null,
        ),
      ],
    );
  }
}
