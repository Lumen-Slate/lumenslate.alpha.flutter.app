import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class GoogleAuth{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  Future<Map<String, dynamic>?> signInGoogle() async {
    GoogleSignIn account = GoogleSignIn();
    try {
      final GoogleSignInAccount? user = await account.signIn();

      final GoogleSignInAuthentication details = await user!.authentication;

      final credential = GoogleAuthProvider.credential(accessToken: details.accessToken, idToken: details.idToken);

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final Map<String, dynamic> userCredentials = {};

      userCredentials['id'] = userCredential.user!.uid;
      userCredentials['email'] = user.email;
      userCredentials['displayName'] = user.displayName ?? '';
      userCredentials['photoUrl'] = user.photoUrl;

      if (userCredential.user != null) {
        _logger.i(" ${userCredential.user!.email} signed in successfully.");

        return userCredentials;
      } else {
        _logger.e("Failed to sign in with Google.");
        return null;
      }
    } catch (e) {
      _logger.e("An error occurred during Google sign-in: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    _logger.i("User signed out successfully.");
  }

  Stream<User?> getCurrentUser() => FirebaseAuth.instance.authStateChanges();
}