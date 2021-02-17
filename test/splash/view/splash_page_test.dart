import 'package:flutter/material.dart';
import 'package:cookpoint/splash/splash.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SplashPage', () {
    testWidgets('renders bloc image', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SplashPage()));
      expect(find.byKey(const Key('splash_bloc_image')), findsOneWidget);
    });
  });
}
