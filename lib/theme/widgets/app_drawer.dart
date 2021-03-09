import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              key: const Key('homePage_MyCooker'),
              leading: const Icon(Icons.face_rounded),
              title: const Text('חשבון'),
              onTap: () => Navigator.of(context).push<void>(
                AuthenticationPage.route(),
              ),
            ),
            ListTile(
              key: const Key('homePage_AddPointPage'),
              leading: const Icon(Icons.fastfood_outlined),
              title: const Text('המאכלים שלי'),
              onTap: () => Navigator.of(context).push<void>(
                PointsPage.route(),
              ),
            ),
            const Divider(),
            ListTile(
              dense: true,
              key: const Key('homePage_REPORT_BUG'),
              leading: const Icon(Icons.bug_report),
              title: const Text('דיווח על בעיות'),
              onTap: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
            ),
            ListTile(
              dense: true,
              key: const Key('homePage_EMAIL_US'),
              leading: const Icon(Icons.support_agent),
              title: const Text('צרו קשר'),
              onTap: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
            ),
            ListTile(
              dense: true,
              key: const Key('homePage_TOS'),
              leading: const Icon(Icons.description),
              title: const Text('תנאים ומדיניות פרטיות'),
              onTap: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
            ),
            ListTile(
              dense: true,
              key: const Key('homePage_ABOUT_US'),
              leading: const Icon(Icons.info),
              title: const Text('אודות CookPoint'),
              onTap: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
            ),
          ],
        ),
      ),
    );
  }
}
