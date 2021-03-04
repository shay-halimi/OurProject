import 'package:cookpoint/location/cubit/cubit.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/products/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:location_services/gps_location_services.dart';

import 'map/map.dart';
import 'theme/theme.dart';

class HomePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: const Key('GPSLocationServices'),
      create: (_) =>
          LocationCubit(locationServices: GPSLocationServices())..locate(),
      child: BlocProvider(
        key: const Key('MapCubit'),
        create: (_) => MapCubit(),
        child: BlocListener<LocationCubit, LocationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state.status == LocationStateStatus.located) {
              context.read<MapCubit>().updateLocation(state.current);
            }
          },
          child: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          MapWidget(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  const LocateButton(),
                ],
              ),
              _productsBar(context),
            ],
          ),
        ],
      ),
      appBar: MapAppBar(
        title: const TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'מה בא לך לאכול?',
          ),
          keyboardType: TextInputType.text,
        ),
      ),
      endDrawer: AppDrawer(),
    );
  }

  Widget _productsBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Swiper(
        loop: false,
        itemWidth: MediaQuery.of(context).size.width - 16.0,
        itemBuilder: (_, index) {
          return ProductWidget.fake(index.toString());
        },
        itemCount: 15,
        viewportFraction: 0.9,
        scale: 0.95,
      ),
    );
  }
}
