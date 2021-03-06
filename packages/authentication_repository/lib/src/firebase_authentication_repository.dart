import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'authentication_repository.dart';
import 'models/models.dart';

class FirebaseAuthenticationRepository extends AuthenticationRepository {
  FirebaseAuthenticationRepository({
    firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Future<Verification> sendOTP({String phoneNumber}) async {
    final completer = Completer<Verification>();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(
        seconds: 60,
      ),
      verificationCompleted: (phoneAuthCredential) async {
        await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      },
      codeSent: (verificationId, _) {
        completer.complete(Verification(id: verificationId));
      },
      verificationFailed: (error) {
        completer.completeError(error);
      },
      codeAutoRetrievalTimeout: (_) {
        if (completer.isCompleted) return;

        completer.completeError(Exception('Code auto retrieval timeout'));
      },
    );

    return completer.future;
  }

  @override
  Future<void> signIn({
    String otp,
    Verification verification,
  }) async {
    try {
      await _firebaseAuth.signInWithCredential(
        firebase_auth.PhoneAuthProvider.credential(
          verificationId: verification.id,
          smsCode: otp,
        ),
      );
    } on Exception {
      throw SignInFailure();
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }

  @override
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser == null ? User.empty : firebaseUser.toUser;
    });
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(
      id: uid,
      phoneNumber: phoneNumber,
    );
  }
}
