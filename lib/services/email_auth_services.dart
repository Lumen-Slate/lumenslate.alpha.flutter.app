import 'package:firebase_auth/firebase_auth.dart';

import 'logging_service.dart';

class EmailAuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Sign up with email and password
  Future<Map<String, dynamic>?> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(displayName);
        await user.reload();
        await _auth.signOut();

        return {
          'id': user.uid,
          'email': user.email ?? '',
          'displayName': displayName,
          'photoUrl': user.photoURL,
        };
      }
      return null;
    } on FirebaseAuthException catch (e) {
      LoggingService.auth('Email sign up error: ${e.code} - ${e.message}', exception: e);
      throw _handleAuthException(e);
    } catch (e) {
      LoggingService.auth('Unexpected sign up error: $e', exception: e);
      throw 'An unexpected error occurred during sign up';
    }
  }

  /// Sign in with email and password
  Future<Map<String, dynamic>?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;
      if (user != null) {
        return {
          'id': user.uid,
          'email': user.email ?? '',
          'displayName': user.displayName ?? '',
          'photoUrl': user.photoURL,
        };
      }
      return null;
    } on FirebaseAuthException catch (e) {
      LoggingService.auth('Email sign in error: ${e.code} - ${e.message}', exception: e);
      throw _handleAuthException(e);
    } catch (e) {
      LoggingService.auth('Unexpected sign in error: $e', exception: e);
      throw 'An unexpected error occurred during sign in';
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      LoggingService.auth('Password reset error: ${e.code} - ${e.message}', exception: e);
      throw _handleAuthException(e);
    } catch (e) {
      LoggingService.auth('Unexpected password reset error: $e', exception: e);
      throw 'An unexpected error occurred while sending password reset email';
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      LoggingService.auth('Sign out error: $e', exception: e);
      throw 'An error occurred while signing out';
    }
  }

  /// Firebase user state stream
  Stream<User?> firebaseUserStream() => _auth.authStateChanges();

  /// Handle Firebase Auth exceptions and return user-friendly messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      case 'invalid-credential':
        return 'The supplied account is malformed or has expired.';
      default:
        return e.message ?? 'An unknown error occurred.';
    }
  }
}
