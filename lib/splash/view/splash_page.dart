import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/splash'),
      builder: (_) => const SplashPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SplashBody(),
    );
  }
}

class SplashBody extends StatelessWidget {
  const SplashBody({
    Key key,
    this.child = const CircularProgressIndicator(),
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppCover(),
          ],
        ),
        ConstrainedBox(constraints: const BoxConstraints(minHeight: 32)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            child,
          ],
        ),
      ],
    );
  }
}
