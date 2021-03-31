import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';

import 'authentication_repository.dart';
import 'models/models.dart';

class FakeAuthenticationRepository extends AuthenticationRepository {
  FakeAuthenticationRepository() {
    signIn(
      otp: '',
      verification: Verification(id: '+972211${100000 + rand.nextInt(899999)}'),
    );
  }

  final rand = Random();

  final StreamController<User> _streamController = StreamController();

  @override
  Future<void> logOut() async {
    _streamController.add(User.empty);
  }

  @override
  Future<Verification> sendOTP({@required String phoneNumber}) async {
    return Verification(id: phoneNumber);
  }

  @override
  Future<void> signIn({
    @required String otp,
    @required Verification verification,
  }) async {
    _streamController.add(User(
      id: verification.id,
      phoneNumber: verification.id,
    ));
  }

  @override
  Stream<User> get user => _streamController.stream;
}
