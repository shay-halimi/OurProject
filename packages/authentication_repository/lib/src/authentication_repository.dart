import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';

import 'models/models.dart';

class SendOTPFailure implements Exception {}

class SignInFailure implements Exception {}

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

  Future<String> sendOTP({
    @required String phoneNumber,
  }) async {
    final completer = Completer<String>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(
        seconds: 60,
      ),
      verificationCompleted: (firebase_auth.PhoneAuthCredential pac) async {
        await _firebaseAuth.signInWithCredential(pac);
        completer.complete('');
      },
      verificationFailed: (e) {
        completer.completeError(e);
      },
      codeSent: (String verificationId, [int forceResendingToken]) {
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        completer.complete(verificationId);
      },
    );

    return completer.future;
  }

  Future<void> signInWithCredential({
    @required String otp,
    @required String verificationId,
  }) async {
    try {
      await _firebaseAuth.signInWithCredential(
        firebase_auth.PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        ),
      );
    } on Exception {
      throw SignInFailure();
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
