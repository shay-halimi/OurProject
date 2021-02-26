import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';

import 'models/models.dart';

class SendOTPFailure implements Exception {}

class SignInWithCredentialFailure implements Exception {}

class LogOutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository({
    firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
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
      verificationCompleted: (firebase_auth.PhoneAuthCredential pac) async {
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
    @required String otp,
  }) async {
    assert(otp != null);
    try {
      await _firebaseAuth.signInWithCredential(
        firebase_auth.PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: otp,
        ),
      );
    } on Exception {
      throw SignInWithCredentialFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
      id: uid,
      displayName: displayName,
      photoURL: photoURL,
      phoneNumber: phoneNumber,
    );
  }
}
