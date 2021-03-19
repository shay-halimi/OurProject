import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/app.dart';
import 'package:cookpoint/simple_bloc_observer.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:location_services/location_services.dart';
import 'package:points_repository/points_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(App(
    authenticationRepository: FirebaseAuthenticationRepository(),
    pointsRepository: FirebasePointsRepository(),
    locationServices: GeoLocatorLocationServices(),
    cookersRepository: FirebaseCookersRepository(),
  ));
}
