import 'package:cookpoint/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(
        name: '/settings',
      ),
      builder: (_) => const SettingsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              key: const Key('Settings_Hebrew_ListTile'),
              leading: const Icon(Icons.language),
              title: const Text('עברית'),
              onTap: () => context
                  .read<SettingsCubit>()
                  .setLocale(SettingsLocale.hebrew),
            ),
            ListTile(
              key: const Key('Settings_English_ListTile'),
              leading: const Icon(Icons.language),
              title: const Text('English'),
              onTap: () => context
                  .read<SettingsCubit>()
                  .setLocale(SettingsLocale.english),
            ),
          ],
        ),
      ),
    );
  }
}
