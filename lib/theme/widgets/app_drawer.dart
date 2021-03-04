import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/products/products.dart';
import 'package:cookpoint/profiles/profiles.dart';
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
              key: const Key('homePage_MyProfile'),
              leading: const Icon(Icons.face_rounded),
              title: const Text('הפרופיל שלי'),
              onTap: () => Navigator.of(context).push<void>(
                ProfilePage.route(),
              ),
            ),
            ListTile(
              key: const Key('homePage_AddProductPage'),
              leading: const Icon(Icons.fastfood_outlined),
              title: const Text('התפריט שלי'),
              onTap: () => Navigator.of(context).push<void>(
                AddProductPage.route(),
              ),
            ),
            const Divider(),
            ListTile(
              key: const Key('homePage_LogoutRequested'),
              leading: const Icon(Icons.exit_to_app),
              title: const Text('התנתק'),
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
