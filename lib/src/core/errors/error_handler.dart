import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hajjmate/src/core/errors/exceptions.dart';
import 'package:hajjmate/src/core/errors/failures.dart';

class ErrorHandler {
  Failure handle(Object error) {
    if (error is TimeoutException) return const NetworkFailure();
    if (error is FirebaseAuthException) return _fromAuth(error);
    if (error is FirebaseException) return _fromFirebase(error);
    if (error is ProfileNotFoundException) {
      return const AuthFailure(message: 'Your profile was not found.');
    }
    return const UnknownFailure();
  }

  Failure _fromAuth(FirebaseAuthException error) {
    return switch (error.code) {
      'network-request-failed' => const NetworkFailure(),
      'invalid-email' => const AuthFailure(
        message: 'The email address is not valid.',
      ),
      'user-not-found' || 'wrong-password' || 'invalid-credential' =>
        const AuthFailure(message: 'Email or password is incorrect.'),
      'email-already-in-use' => const AuthFailure(
        message: 'This email is already registered.',
      ),
      'weak-password' => const AuthFailure(
        message: 'The password is too weak. Use at least 6 characters.',
      ),
      'user-disabled' => const AuthFailure(
        message: 'This account has been disabled.',
      ),
      'too-many-requests' => const AuthFailure(
        message: 'Too many attempts. Try again later.',
      ),
      _ => const AuthFailure(),
    };
  }

  Failure _fromFirebase(FirebaseException error) {
    return switch (error.code) {
      'unavailable' => const NetworkFailure(),
      'permission-denied' => const PermissionFailure(),
      _ => const ServerFailure(),
    };
  }
}
