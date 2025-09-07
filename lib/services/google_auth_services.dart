import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _gs = GoogleSignIn.instance;
  final Logger _logger = Logger();

  StreamSubscription? _eventsSub;
  bool _isInitialized = false;

  /// Initialize Google Sign-In (required for v7.x)
  Future<void> initialize({String? clientId, String? serverClientId}) async {
    if (_isInitialized) return;
    try {
      await _gs.initialize(clientId: clientId, serverClientId: serverClientId);

      _eventsSub = _gs.authenticationEvents.listen((event) {
        _logger.i('GoogleAuthService Auth Event: $event');
      });

      // Try lightweight auth automatically
      _gs.attemptLightweightAuthentication();
      _isInitialized = true;
    } catch (e) {
      _logger.e('GoogleAuthService initialization failed: $e');
    }
  }

  /// Sign in with Google across all platforms
  Future<Map<String, dynamic>?> signIn() async {
    try {
      if (_gs.supportsAuthenticate()) {
        // Mobile/Desktop authentication
        final account = await _gs.authenticate(scopeHint: const ['email']);
        final cred = await _firebaseCredential(account);
        final uc = await _auth.signInWithCredential(cred);
        return _toUserMap(account, uc);
      } else if (kIsWeb) {
        // Use FirebaseAuth popup on Web
        final uc = await _auth.signInWithPopup(GoogleAuthProvider().setCustomParameters({'prompt': 'select_account'}));
        final user = uc.user;
        if (user == null) return null;
        return {
          'id': user.uid,
          'email': user.email ?? '',
          'displayName': user.displayName ?? '',
          'photoUrl': user.photoURL,
        };
      } else {
        return null;
      }
    } on GoogleSignInException catch (e) {
      _logger.e('Google Sign-In error: ${e.code.name}, ${e.description}');
      return null;
    } catch (e) {
      _logger.e('Unexpected sign-in error: $e');
      return null;
    }
  }

  /// Sign out from Firebase and Google
  Future<void> signOut() async {
    await _auth.signOut();
    await _gs.signOut();
  }

  /// Firebase user state stream
  Stream<User?> firebaseUserStream() => _auth.authStateChanges();

  /// Build Firebase credential from Google account
  Future<AuthCredential> _firebaseCredential(GoogleSignInAccount account) async {
    final basic = account.authentication; // synchronous
    const scopes = <String>['email'];
    final client = account.authorizationClient;
    final existing = await client.authorizationForScopes(scopes);
    final auths = existing ?? await client.authorizeScopes(scopes);

    return GoogleAuthProvider.credential(idToken: basic.idToken, accessToken: auths.accessToken);
  }

  /// Convert account and userCredential to map
  Map<String, dynamic> _toUserMap(GoogleSignInAccount a, UserCredential uc) {
    return {'id': uc.user?.uid ?? '', 'email': a.email, 'displayName': a.displayName ?? '', 'photoUrl': a.photoUrl};
  }

  Future<void> dispose() async {
    await _eventsSub?.cancel();
  }
}
