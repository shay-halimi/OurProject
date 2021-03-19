import 'dart:async';

import 'authentication_repository.dart';
import 'models/models.dart';

class FakeAuthenticationRepository extends AuthenticationRepository {
  FakeAuthenticationRepository() {
    logOut();
  }

  final StreamController<User> _streamController = StreamController();

  @override
  Future<void> logOut() async {
    _streamController.add(User.empty);
  }

  @override
  Future<Verification> sendOTP({String phoneNumber}) async {
    return Verification(id: phoneNumber);
  }

  @override
  Future<void> signIn({
    String otp,
    Verification verification,
  }) async {
    _streamController.add(User(
      id: verification.id,
      phoneNumber: verification.id,
    ));
  }

  @override
  Stream<User> get user => _streamController.stream;
}
