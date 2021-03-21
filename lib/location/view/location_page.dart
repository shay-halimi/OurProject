import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LocationPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'בכדי להמשיך יש להפעיל את שירותי המיקום במכשירך.',
                    style: theme.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('נסה שוב'),
                  onPressed: context.read<LocationCubit>().locate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
