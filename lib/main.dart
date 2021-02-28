import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cookpoint/app.dart';
import 'package:cookpoint/simple_bloc_observer.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:places_repository/location_places_repository.dart';
import 'package:points_repository/firebase_points_repository.dart';
import 'package:profiles_repository/profiles_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    profilesRepository: FirebaseProfilesRepository(),
    pointsRepository: FirebasePointsRepository(),
    placesRepository: LocationPlacesRepository(),
  ));
}
