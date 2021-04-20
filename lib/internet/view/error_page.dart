import 'package:cookpoint/internet/internet.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/internet/error'),
      builder: (_) => const ErrorPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBody(
        child: Expanded(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.wifi_off),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context).internetError,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.refresh),
        label: Text(AppLocalizations.of(context).tryAgainBtn),
        onPressed: () => context.read<InternetCubit>().check(),
      ),
    );
  }
}
