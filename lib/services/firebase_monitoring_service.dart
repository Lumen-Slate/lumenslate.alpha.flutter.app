import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

/// Service for managing Firebase Crashlytics and Performance Monitoring
class FirebaseMonitoringService {
  static const String _tag = 'FirebaseMonitoringService';
  
  static FirebaseCrashlytics? _crashlytics;
  static FirebasePerformance? _performance;
  static bool _initialized = false;

  /// Initialize Firebase monitoring services
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Only initialize in release/production builds
      if (kDebugMode) {
        if (kDebugMode) {
          print('$_tag: Skipping Firebase monitoring initialization in debug mode');
        }
        _initialized = true;
        return;
      }

      // Initialize Crashlytics
      _crashlytics = FirebaseCrashlytics.instance;
      
      // Initialize Performance Monitoring
      _performance = FirebasePerformance.instance;

      // Configure Crashlytics
      await _configureCrashlytics();

      // Configure Performance Monitoring
      await _configurePerformanceMonitoring();

      _initialized = true;

      if (kDebugMode) {
        print('$_tag: Firebase monitoring services initialized successfully');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('$_tag: Failed to initialize Firebase monitoring: $e');
        print('$_tag: Stack trace: $stackTrace');
      }
    }
  }

  /// Configure Firebase Crashlytics
  static Future<void> _configureCrashlytics() async {
    if (_crashlytics == null) return;

    try {
      // Enable automatic collection of crash reports
      await _crashlytics!.setCrashlyticsCollectionEnabled(true);

      // Set up custom keys for better debugging
      await _crashlytics!.setCustomKey('platform', Platform.operatingSystem);
      await _crashlytics!.setCustomKey('app_version', '0.0.12+2'); // Should match pubspec.yaml
      await _crashlytics!.setCustomKey('build_mode', kDebugMode ? 'debug' : 'release');

      if (kDebugMode) {
        print('$_tag: Crashlytics configured successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Failed to configure Crashlytics: $e');
      }
    }
  }

  /// Configure Firebase Performance Monitoring
  static Future<void> _configurePerformanceMonitoring() async {
    if (_performance == null) return;

    try {
      // Enable automatic performance data collection
      await _performance!.setPerformanceCollectionEnabled(true);

      if (kDebugMode) {
        print('$_tag: Performance monitoring configured successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Failed to configure Performance monitoring: $e');
      }
    }
  }

  /// Log a non-fatal error to Crashlytics
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Iterable<Object> information = const [],
    bool fatal = false,
  }) async {
    // Skip in debug mode
    if (kDebugMode) {
      if (kDebugMode) {
        print('$_tag: Debug mode - skipping error recording: $exception');
      }
      return;
    }

    if (_crashlytics == null) {
      if (kDebugMode) {
        print('$_tag: Crashlytics not initialized, cannot record error: $exception');
      }
      return;
    }

    try {
      await _crashlytics!.recordError(
        exception,
        stackTrace,
        reason: reason,
        information: information,
        fatal: fatal,
      );

      if (kDebugMode) {
        print('$_tag: Error recorded to Crashlytics: $exception');
      }
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Failed to record error to Crashlytics: $e');
      }
    }
  }

  /// Log a message to Crashlytics
  static Future<void> log(String message) async {
    // Skip in debug mode
    if (kDebugMode) {
      if (kDebugMode) {
        print('$_tag: Debug mode - skipping log: $message');
      }
      return;
    }

    if (_crashlytics == null) {
      if (kDebugMode) {
        print('$_tag: Crashlytics not initialized, cannot log message: $message');
      }
      return;
    }

    try {
      await _crashlytics!.log(message);

      if (kDebugMode) {
        print('$_tag: Message logged to Crashlytics: $message');
      }
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Failed to log message to Crashlytics: $e');
      }
    }
  }

  /// Set user identifier for Crashlytics
  static Future<void> setUserIdentifier(String identifier) async {
    if (_crashlytics == null) return;

    try {
      await _crashlytics!.setUserIdentifier(identifier);

      if (kDebugMode) {
        print('$_tag: User identifier set: $identifier');
      }
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Failed to set user identifier: $e');
      }
    }
  }

  /// Set custom key-value pairs for Crashlytics
  static Future<void> setCustomKey(String key, Object value) async {
    if (_crashlytics == null) return;

    try {
      await _crashlytics!.setCustomKey(key, value);

      if (kDebugMode) {
        print('$_tag: Custom key set: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Failed to set custom key: $e');
      }
    }
  }

  /// Create a custom performance trace
  static Trace? newTrace(String traceName) {
    // Skip in debug mode
    if (kDebugMode) {
      if (kDebugMode) {
        print('$_tag: Debug mode - skipping performance trace: $traceName');
      }
      return null;
    }

    if (_performance == null) {
      if (kDebugMode) {
        print('$_tag: Performance monitoring not initialized, cannot create trace: $traceName');
      }
      return null;
    }

    try {
      final trace = _performance!.newTrace(traceName);
      if (kDebugMode) {
        print('$_tag: Performance trace created: $traceName');
      }
      return trace;
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Failed to create performance trace: $e');
      }
      return null;
    }
  }

  /// Create a custom HTTP metric
  static HttpMetric? newHttpMetric(String url, HttpMethod httpMethod) {
    if (_performance == null) {
      if (kDebugMode) {
        print('$_tag: Performance monitoring not initialized, cannot create HTTP metric: $url');
      }
      return null;
    }

    try {
      final metric = _performance!.newHttpMetric(url, httpMethod);
      if (kDebugMode) {
        print('$_tag: HTTP metric created: $url');
      }
      return metric;
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Failed to create HTTP metric: $e');
      }
      return null;
    }
  }

  /// Wrapper for measuring the performance of a function
  static Future<T> measurePerformance<T>(
    String traceName,
    Future<T> Function() function, {
    Map<String, String>? attributes,
  }) async {
    final trace = newTrace(traceName);
    
    if (trace == null) {
      // If performance monitoring is not available, just execute the function
      return await function();
    }

    try {
      // Add custom attributes if provided
      if (attributes != null) {
        for (final entry in attributes.entries) {
          trace.putAttribute(entry.key, entry.value);
        }
      }

      // Start the trace
      await trace.start();

      // Execute the function
      final result = await function();

      // Stop the trace
      await trace.stop();

      if (kDebugMode) {
        print('$_tag: Performance trace completed: $traceName');
      }

      return result;
    } catch (e, stackTrace) {
      // Stop the trace even if an error occurred
      try {
        await trace.stop();
      } catch (_) {}

      // Record the error
      await recordError(e, stackTrace, reason: 'Error in performance trace: $traceName');

      if (kDebugMode) {
        print('$_tag: Error in performance trace $traceName: $e');
      }

      rethrow;
    }
  }

  /// Log app-specific events
  static Future<void> logAppEvent(String event, {Map<String, String>? parameters}) async {
    try {
      final message = parameters != null 
          ? '$event: ${parameters.entries.map((e) => '${e.key}=${e.value}').join(', ')}'
          : event;
      
      await log(message);

      if (kDebugMode) {
        print('$_tag: App event logged: $message');
      }
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Failed to log app event: $e');
      }
    }
  }

  /// Log authentication events
  static Future<void> logAuthEvent(String event, {String? userId, String? method}) async {
    final parameters = <String, String>{
      'event_type': 'authentication',
      if (userId != null) 'user_id': userId,
      if (method != null) 'auth_method': method,
    };

    await logAppEvent(event, parameters: parameters);
  }

  /// Log export/download events
  static Future<void> logExportEvent(String exportType, {String? fileName, bool success = true}) async {
    final parameters = <String, String>{
      'event_type': 'export',
      'export_type': exportType,
      'success': success.toString(),
      if (fileName != null) 'file_name': fileName,
    };

    await logAppEvent('file_export', parameters: parameters);
  }

  /// Log API-related events
  static Future<void> logApiEvent(String endpoint, {int? statusCode, String? method}) async {
    final parameters = <String, String>{
      'event_type': 'api_call',
      'endpoint': endpoint,
      if (statusCode != null) 'status_code': statusCode.toString(),
      if (method != null) 'method': method,
    };

    await logAppEvent('api_call', parameters: parameters);
  }

  /// Check if monitoring services are initialized
  static bool get isInitialized => _initialized;

  /// Check if Crashlytics is available
  static bool get isCrashlyticsAvailable => _crashlytics != null;

  /// Check if Performance monitoring is available
  static bool get isPerformanceMonitoringAvailable => _performance != null;
}