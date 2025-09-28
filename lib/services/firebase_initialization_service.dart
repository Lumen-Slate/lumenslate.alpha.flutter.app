import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import '../firebase_options.dart';

class FirebaseInitializationService {
  static final Logger _logger = Logger();
  static bool _isInitialized = false;
  
  /// Ensures Firebase is properly initialized before any services try to access it
  static Future<void> ensureInitialized() async {
    if (_isInitialized) {
      return;
    }
    
    try {
      if (Firebase.apps.isEmpty) {
        _logger.i('Initializing Firebase...');
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        _logger.i('Firebase initialized successfully');
      } else {
        _logger.i('Firebase already initialized');
      }
      _isInitialized = true;
    } catch (e) {
      _logger.e('Failed to initialize Firebase: $e');
      rethrow;
    }
  }
  
  /// Check if Firebase is initialized
  static bool get isInitialized => _isInitialized;
}