import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'firebase_monitoring_service.dart';

/// Centralized logging service that standardizes logging across the app
/// Uses the logger package for consistent formatting and output
/// Integrates with Firebase Crashlytics for production error reporting
class LoggingService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      dateTimeFormat:
          DateTimeFormat.none, // Should each log print contain a timestamp
    ),
  );

  /// Log verbose/trace level messages (only shown in debug mode)
  static void trace(String message, {String? tag}) {
    if (kDebugMode) {
      _logger.t(_formatMessage(message, tag));
    }
  }

  /// Log debug level messages (only shown in debug mode)
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      _logger.d(_formatMessage(message, tag));
    }
  }

  /// Log info level messages
  static void info(String message, {String? tag}) {
    _logger.i(_formatMessage(message, tag));
  }

  /// Log warning level messages
  static void warning(String message, {String? tag}) {
    _logger.w(_formatMessage(message, tag));
  }

  /// Log error level messages and optionally send to Firebase Crashlytics
  static void error(
    String message, {
    String? tag,
    dynamic exception,
    StackTrace? stackTrace,
    bool sendToCrashlytics = true,
  }) {
    final formattedMessage = _formatMessage(message, tag);
    _logger.e(formattedMessage, error: exception, stackTrace: stackTrace);

    // Send to Firebase Crashlytics in production if enabled
    if (sendToCrashlytics && !kDebugMode) {
      FirebaseMonitoringService.recordError(
        exception ?? Exception(formattedMessage),
        stackTrace,
        reason: formattedMessage,
      );
    }
  }

  /// Log fatal level messages and send to Firebase Crashlytics
  static void fatal(
    String message, {
    String? tag,
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    final formattedMessage = _formatMessage(message, tag);
    _logger.f(formattedMessage, error: exception, stackTrace: stackTrace);

    // Always send fatal errors to Firebase Crashlytics
    if (!kDebugMode) {
      FirebaseMonitoringService.recordError(
        exception ?? Exception(formattedMessage),
        stackTrace,
        reason: formattedMessage,
        fatal: true,
      );
    }
  }

  /// Log HTTP request/response information
  static void http(String message, {String? tag}) {
    if (kDebugMode) {
      _logger.d(_formatMessage('[HTTP] $message', tag));
    }
  }

  /// Log authentication related messages
  static void auth(
    String message, {
    String? tag,
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    if (exception != null || stackTrace != null) {
      error(
        '[AUTH] $message',
        tag: tag,
        exception: exception,
        stackTrace: stackTrace,
      );
    } else {
      debug('[AUTH] $message', tag: tag);
    }
  }

  /// Log permission related messages
  static void permission(String message, {String? tag}) {
    debug('[PERMISSION] $message', tag: tag);
  }

  /// Log Firebase related messages
  static void firebase(
    String message, {
    String? tag,
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    if (exception != null || stackTrace != null) {
      error(
        '[FIREBASE] $message',
        tag: tag,
        exception: exception,
        stackTrace: stackTrace,
      );
    } else {
      debug('[FIREBASE] $message', tag: tag);
    }
  }

  /// Log export/file operation related messages
  static void export(
    String message, {
    String? tag,
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    if (exception != null || stackTrace != null) {
      error(
        '[EXPORT] $message',
        tag: tag,
        exception: exception,
        stackTrace: stackTrace,
      );
    } else {
      debug('[EXPORT] $message', tag: tag);
    }
  }

  /// Log notification related messages
  static void notification(
    String message, {
    String? tag,
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    if (exception != null || stackTrace != null) {
      error(
        '[NOTIFICATION] $message',
        tag: tag,
        exception: exception,
        stackTrace: stackTrace,
      );
    } else {
      debug('[NOTIFICATION] $message', tag: tag);
    }
  }

  /// Format message with optional tag
  static String _formatMessage(String message, String? tag) {
    if (tag != null && tag.isNotEmpty) {
      return '[$tag] $message';
    }
    return message;
  }

  /// Set custom log level (for testing or specific scenarios)
  static void setLogLevel(Level level) {
    Logger.level = level;
  }

  /// Enable/disable logger output
  static void setEnabled(bool enabled) {
    if (!enabled) {
      Logger.level = Level.off;
    } else {
      Logger.level = Level.trace;
    }
  }

  /// Record a custom event (useful for analytics and debugging)
  static void recordEvent(String event, Map<String, dynamic> parameters) {
    debug('Event: $event, Parameters: $parameters', tag: 'ANALYTICS');

    // Send to Firebase Analytics if in production
    if (!kDebugMode) {
      FirebaseMonitoringService.recordEvent(event, parameters);
    }
  }

  /// Record a breadcrumb for debugging purposes
  static void breadcrumb(String message, {String? category}) {
    debug('Breadcrumb: $message', tag: category ?? 'BREADCRUMB');

    // Send to Firebase Crashlytics breadcrumbs if in production
    if (!kDebugMode) {
      FirebaseMonitoringService.recordBreadcrumb(message, category: category);
    }
  }
}
