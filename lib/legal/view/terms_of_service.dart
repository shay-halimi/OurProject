import 'dart:async';

import 'package:cookpoint/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({
    Key key,
    this.title,
    this.onPressed,
    this.url,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/legal/terms-of-service'),
      builder: (_) => const TermsOfService(),
    );
  }

  /// @nullable
  final Widget title;

  /// @nullable
  final VoidCallback onPressed;

  /// @nullable
  final String url;

  @override
  Widget build(BuildContext context) {
    final _completer = Completer<bool>();

    return Scaffold(
      appBar: AppBar(
        title: title ?? const Text('תנאים ומדיניות פרטיות'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: WebView(
                initialUrl: url ??
                    'https://cookpoint.app/1/policies/terms-of-service.html',
                onPageFinished: (_) => _completer.complete(true),
                onWebResourceError: (_) => _completer.complete(false),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<bool>(
                future: _completer.future,
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
                    return ElevatedButton(
                      onPressed:
                          onPressed ?? () => Navigator.of(context).pop(true),
                      child: const Text('אני מקבל/ת את תנאי השירות'),
                    );
                  }
                  return const LinearProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TermsOfServiceMiddleware extends StatelessWidget {
  TermsOfServiceMiddleware({
    Key key,
    this.child,
  }) : super(key: key);

  static const tosVersion = 1;
  static const tosVersionKey = 'tos_version';

  final _stream = StreamController<bool>();

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init(),
      builder: (_, __) {
        return StreamBuilder<bool>(
          stream: _stream.stream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data ? child : TermsOfService(onPressed: _accept);
            }

            return const SplashPage();
          },
        );
      },
    );
  }

  Future<void> _init() {
    return SharedPreferences.getInstance()
        .then((prefs) => (prefs.getInt(tosVersionKey) ?? 0) == tosVersion)
        .then(_stream.add);
  }

  Future<void> _accept() {
    return SharedPreferences.getInstance()
        .then((prefs) => (prefs.setInt(tosVersionKey, tosVersion)))
        .then(_stream.add);
  }
}

class CookTermsOfService extends StatelessWidget {
  const CookTermsOfService({
    Key key,
    this.onPressed,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/legal/partners/terms-of-service'),
      builder: (_) => const CookTermsOfService(),
    );
  }

  /// @nullable
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TermsOfService(
      title: const Text('תנאים ומדיניות פרטיות שותפים'),
      onPressed: onPressed,
      url: 'https://cookpoint.app/1/policies/refund-policy.html',
    );
  }
}

class CookTermsOfServiceMiddleware extends StatelessWidget {
  CookTermsOfServiceMiddleware({
    Key key,
    this.child,
  }) : super(key: key);

  static const tosVersion = 1;
  static const tosVersionKey = 'cook_tos_version';

  final _stream = StreamController<bool>();

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _init(),
      builder: (_, __) {
        return StreamBuilder<bool>(
          stream: _stream.stream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data
                  ? child
                  : CookTermsOfService(onPressed: _accept);
            }

            return const SplashPage();
          },
        );
      },
    );
  }

  Future<void> _init() {
    return SharedPreferences.getInstance()
        .then((prefs) => (prefs.getInt(tosVersionKey) ?? 0) == tosVersion)
        .then(_stream.add);
  }

  Future<void> _accept() {
    return SharedPreferences.getInstance()
        .then((prefs) => (prefs.setInt(tosVersionKey, tosVersion)))
        .then(_stream.add);
  }
}
