import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';

import 'authentication_repository.dart';
import 'models/models.dart';

class FakeAuthenticationRepository extends AuthenticationRepository {
  FakeAuthenticationRepository() {
    final id = 1000000 + Random().nextInt(8999999);

    signIn(
      otp: '$id',
      verification: Verification(id: '+97221$id'),
    );
  }

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
      id: otp,
      phoneNumber: verification.id,
    ));
  }

  @override
  Stream<User> get user => _streamController.stream;
}
