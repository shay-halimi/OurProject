import 'dart:async';

import 'package:meta/meta.dart';

import 'models/models.dart';

class SendOTPFailure implements Exception {}

class SignInFailure implements Exception {}

class LogOutFailure implements Exception {}

abstract class AuthenticationRepository {
  Future<Verification> sendOTP({
    @required String phoneNumber,
  });

  Future<void> signIn({
    @required String otp,
    @required Verification verification,
  });

  Future<void> logOut();

  Stream<User> get user;
}
