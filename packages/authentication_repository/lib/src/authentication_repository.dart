import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, PhoneAuthCredential, PhoneAuthProvider, User;
import 'package:meta/meta.dart';

import 'models/models.dart' as domain;

class SendOTPFailure implements Exception {}

class SignInWithCredentialFailure implements Exception {}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository({
    FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  Stream<domain.User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? domain.User.empty : firebaseUser.toUser;
    });
  }

  String _verificationId;

  Future<void> sendOTP({
    @required String phoneNumber,
  }) async {
    assert(phoneNumber != null);

    var completer = Completer<void>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(
        seconds: 60,
      ),
      verificationCompleted: (PhoneAuthCredential pac) async {
        await _firebaseAuth.signInWithCredential(pac);

        completer.complete();
      },
      verificationFailed: (e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        _verificationId = verificationId;

        completer.complete();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;

        completer.complete();
      },
    );

    return completer.future;
  }

  Future<void> signInWithCredential({
    @required String oneTimePassword,
  }) async {
    assert(oneTimePassword != null);
    try {
      await _firebaseAuth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: oneTimePassword,
        ),
      );
    } on Exception catch (e) {
      print(e);
      throw SignInWithCredentialFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on Exception catch (e) {
      print(e);
      throw LogOutFailure();
    }
  }
}

extension on User {
  domain.User get toUser {
    return domain.User(id: uid, phoneNumber: phoneNumber);
  }
}
