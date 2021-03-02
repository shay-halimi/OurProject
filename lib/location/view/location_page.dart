import 'package:cookpoint/location/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => LocationPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('שירותי מיקום'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('הפעל שירותי מיקום'),
          onPressed: () => context.read<LocationCubit>().locate(),
        ),
      ),
    );
  }
}
