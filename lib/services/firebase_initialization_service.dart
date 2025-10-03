import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'logging_service.dart';

class FirebaseInitializationService {
  static bool _isInitialized = false;
  
  /// Ensures Firebase is properly initialized before any services try to access it
  static Future<void> ensureInitialized() async {
    if (_isInitialized) {
      return;
    }
    
    try {
      if (Firebase.apps.isEmpty) {
        LoggingService.firebase('Initializing Firebase...');
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        LoggingService.firebase('Firebase initialized successfully');
      } else {
        LoggingService.firebase('Firebase already initialized');
      }
      _isInitialized = true;
    } catch (e) {
      LoggingService.firebase('Failed to initialize Firebase: $e', exception: e);
      rethrow;
    }
  }
  
  /// Check if Firebase is initialized
  static bool get isInitialized => _isInitialized;
}