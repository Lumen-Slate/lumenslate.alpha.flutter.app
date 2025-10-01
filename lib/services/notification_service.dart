import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lumen_slate/services/permission_service.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized || !Platform.isAndroid) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap - open the file
        if (response.payload != null && response.payload!.isNotEmpty) {
          await openFile(response.payload!);
        }
      },
    );

    // Request notification permission using PermissionService for Android 13+
    if (Platform.isAndroid) {
      await PermissionService.requestNotificationPermission();
    }

    _initialized = true;
  }

  /// Show a download complete notification
  static Future<void> showDownloadNotification({
    required String fileName,
    required String filePath,
    String? customTitle,
    String? customMessage,
  }) async {
    if (!Platform.isAndroid) return;

    await initialize();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'File Downloads',
      channelDescription: 'Notifications for downloaded files',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      autoCancel: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final title = customTitle ?? 'Download Complete';
    final message = customMessage ?? 'File saved: $fileName\nTap to open';

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      message,
      platformChannelSpecifics,
      payload: filePath, // Pass file path as payload
    );
  }

  /// Show a general notification
  static Future<void> showNotification({
    required String title,
    required String message,
    String? payload,
    String channelId = 'general_channel',
    String channelName = 'General Notifications',
    String channelDescription = 'General app notifications',
    Importance importance = Importance.defaultImportance,
    Priority priority = Priority.defaultPriority,
  }) async {
    if (!Platform.isAndroid) return;

    await initialize();

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: importance,
      priority: priority,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      autoCancel: true,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      message,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Show a progress notification (useful for long operations)
  static Future<void> showProgressNotification({
    required String title,
    required String message,
    required int progress,
    required int maxProgress,
    String channelId = 'progress_channel',
    String channelName = 'Progress Notifications',
  }) async {
    if (!Platform.isAndroid) return;

    await initialize();

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Progress notifications for ongoing operations',
      importance: Importance.low,
      priority: Priority.low,
      showWhen: false,
      icon: '@mipmap/ic_launcher',
      autoCancel: false,
      ongoing: true,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      999, // Fixed ID for progress notifications
      title,
      message,
      platformChannelSpecifics,
    );
  }

  /// Cancel a specific notification by ID
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Open file using the system's default app
  static Future<bool> openFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        if (kDebugMode) {
          print('File does not exist: $filePath');
        }
        return false;
      }

      // Use open_filex for better cross-platform file opening
      final result = await OpenFilex.open(filePath);
      
      if (result.type == ResultType.done) {
        return true;
      }

      // Fallback methods if open_filex fails
      if (Platform.isAndroid) {
        // Try Android intent
        try {
          final fileExtension = filePath.split('.').last.toLowerCase();
          final mimeType = _getMimeType(fileExtension);
          
          final processResult = await Process.run('am', [
            'start',
            '-a',
            'android.intent.action.VIEW',
            '-d',
            'file://$filePath',
            '-t',
            mimeType,
          ]);

          if (processResult.exitCode == 0) {
            return true;
          }
        } catch (e) {
          if (kDebugMode) {
            print('Android intent failed: $e');
          }
        }
      }

      // Final fallback - try url_launcher
      final uri = Uri.file(filePath);
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to open file: $e');
      }
      return false;
    }
  }

  /// Get MIME type based on file extension
  static String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'csv':
        return 'text/csv';
      case 'txt':
        return 'text/plain';
      case 'doc':
      case 'docx':
        return 'application/msword';
      case 'xls':
      case 'xlsx':
        return 'application/vnd.ms-excel';
      case 'ppt':
      case 'pptx':
        return 'application/vnd.ms-powerpoint';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'mp3':
        return 'audio/mpeg';
      case 'mp4':
        return 'video/mp4';
      default:
        return 'application/octet-stream';
    }
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    if (!Platform.isAndroid) return false;
    
    await initialize();
    
    final permissions = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    
    return permissions ?? false;
  }

  /// Request notification permissions (for Android 13+)
  static Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return false;
    
    await initialize();
    
    final granted = await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    return granted ?? false;
  }
}