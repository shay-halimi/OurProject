import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/launcher.dart';
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
            Image.asset(
              'assets/images/cookpoint.png',
            ),
            const Divider(),
            ListTile(
              key: const Key('AppDrawer_CookerPage_route'),
              leading: const Icon(Icons.face_rounded),
              title: const Text('חשבון'),
              onTap: () => Navigator.of(context).push<void>(
                CookerPage.route(),
              ),
              onLongPress: () => context
                  .read<AuthenticationBloc>()
                  .add(AuthenticationLogoutRequested()),
            ),
            ListTile(
              key: const Key('AppDrawer_PointsPage_ListTile'),
              leading: const Icon(Icons.fastfood_outlined),
              title: const Text('המאכלים שלי'),
              onTap: () => Navigator.of(context).push<void>(
                PointsPage.route(),
              ),
            ),
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
        ),
      ),
    );
  }
}
