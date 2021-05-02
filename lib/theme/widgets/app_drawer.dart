import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/launcher.dart';
import 'package:cookpoint/legal/legal.dart';
import 'package:cookpoint/settings/settings.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: AppCover(),
            ),
            const Divider(),
            ListTile(
              dense: true,
              key: const Key('AppDrawer_SendOnWhatsApp_ListTile'),
              leading: const Icon(Icons.share),
              title: Text(S.of(context).inviteFriendsBtn),
              onTap: () async {
                await launcher.whatsApp('', 'https://cookpoint.app/');
              },
            ),
            ListTile(
              dense: true,
              key: const Key('AppDrawer_AboutUsPage_ListTile'),
              leading: const Icon(Icons.info),
              title: Text(S.of(context).aboutPageTitle),
              onTap: () async {
                final packageInfo = await PackageInfo.fromPlatform();

                showAboutDialog(
                  context: context,
                  applicationIcon: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AppCover(
                      tag: 'AppDrawer_AboutDialog_AppCover',
                      width: 64,
                      height: 64,
                    ),
                  ),
                  applicationVersion:
                      '${packageInfo.version}+${packageInfo.buildNumber}',
                  children: [
                    _aboutDialogData(),
                  ],
                );
              },
            ),
            ListTile(
              dense: true,
              key: const Key('AppDrawer_EmailUs_ListTile'),
              leading: const Icon(Icons.support_agent),
              title: Text(S.of(context).contactUsPageTitle),
              onTap: () async => await launcher.whatsApp('+972538808053'),
            ),
            ListTile(
              dense: true,
              key: const Key('AppDrawer_TOSPage_ListTile'),
              leading: const Icon(Icons.description),
              title: Text(S.of(context).termsOfServicePageTitle),
              onTap: () => Navigator.of(context).push<void>(
                TermsOfService.route(),
              ),
            ),
            ListTile(
              dense: true,
              key: const Key('Settings_English_ListTile'),
              leading: const Icon(Icons.language),
              title: Row(
                children: [
                  TextButton(
                    onPressed: () => context
                        .read<SettingsCubit>()
                        .setLocale(SettingsLocale.english),
                    child: const Text('English'),
                  ),
                  TextButton(
                    onPressed: () => context
                        .read<SettingsCubit>()
                        .setLocale(SettingsLocale.hebrew),
                    child: const Text('עברית'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _aboutDialogData() {
    return const Text('''
אפליקציית שיתוף האוכל שכבשה את ישראל.

CookPoint הינה אפליקציה לפרסום אוכל ביתי שנוצרה עקב קשיי הקורונה.
מטרתנו העיקרית היא לעזור לתושבים שנפגעו כלכלית ולספק להם פלטפורמה פרסומית כדי שיוכלו להרוויח מהמטבח הפרטי. בו זמנית ברצוננו להפגיש בין המשתמשים כדי לייצר שיח פיזי שנפגע במהלך המגפה.

בפלטפורמה ניתן לראות בשלנים שמוכרים אוכל מהמטבח הפרטי ודרכי התקשרות עימם. ניתן בצורה קלה ומהירה להירשם כבשלן ולפרסם את המאכלים שלי ניתן בכל עת להוריד זמינות של אחד הבישולים ולא להיות חשוף לשאר המשתמשים.

לכל בעיה ו/או בקשה ניתן לפנות אלינו דרך המייל שכתובתו cookpointapp@gmail.com ו/או בטלפון שמספרו 054.306.0964.

שיהיה בתאבון,
CookPoint''');
  }
}
