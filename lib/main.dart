import 'package:bloc/bloc.dart';
import 'package:cookpoint/app.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:cookpoint/settings/settings.dart';
import 'package:cookpoint/simple_bloc_observer.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  await SettingsCubit.initialize();
  runApp(App(
    authenticationRepository: FirebaseAuthenticationRepository(),
    foodsRepository: FirebaseFoodsRepository(),
    locationServices: GeoLocatorLocationServices(),
    restaurantsRepository: FirebaseRestaurantsRepository(),
  ));
}
