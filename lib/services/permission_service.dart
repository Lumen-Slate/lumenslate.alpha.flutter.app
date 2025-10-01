import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;

/// Service for managing all app permissions centrally
class PermissionService {
  static const String _tag = 'PermissionService';

  /// Check if storage permission is required for the current platform and Android version
  static Future<bool> isStoragePermissionRequired() async {
    if (!Platform.isAndroid) return false;

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    // Android 13+ (API 33+) uses granular media permissions instead of storage
    return androidInfo.version.sdkInt < 33;
  }

  /// Request storage permission for Android devices
  /// Returns true if permission is granted or not required
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      // Android 13+ (API 33+) doesn't need WRITE_EXTERNAL_STORAGE for Downloads folder
      if (androidInfo.version.sdkInt >= 33) {
        if (kDebugMode) {
          print('$_tag: Android 13+ detected, storage permission not required');
        }
        return true;
      }

      // For Android 12 and below, request storage permission
      final status = await permission_handler.Permission.storage.request();
      final isGranted = status.isGranted;

      if (kDebugMode) {
        print('$_tag: Storage permission ${isGranted ? 'granted' : 'denied'}');
      }

      return isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error requesting storage permission: $e');
      }
      return false;
    }
  }

  /// Check current storage permission status
  static Future<permission_handler.PermissionStatus> getStoragePermissionStatus() async {
    if (!Platform.isAndroid) return permission_handler.PermissionStatus.granted;

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      // Android 13+ doesn't need storage permission for Downloads
      if (androidInfo.version.sdkInt >= 33) {
        return permission_handler.PermissionStatus.granted;
      }

      return await permission_handler.Permission.storage.status;
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error checking storage permission status: $e');
      }
      return permission_handler.PermissionStatus.denied;
    }
  }

  /// Request notification permission
  /// Returns true if permission is granted or not required
  static Future<bool> requestNotificationPermission() async {
    try {
      final status = await permission_handler.Permission.notification.request();
      final isGranted = status.isGranted;

      if (kDebugMode) {
        print('$_tag: Notification permission ${isGranted ? 'granted' : 'denied'}');
      }

      return isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error requesting notification permission: $e');
      }
      return false;
    }
  }

  /// Check current notification permission status
  static Future<permission_handler.PermissionStatus> getNotificationPermissionStatus() async {
    try {
      return await permission_handler.Permission.notification.status;
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error checking notification permission status: $e');
      }
      return permission_handler.PermissionStatus.denied;
    }
  }

  /// Request media permissions for Android 13+
  /// Returns true if permissions are granted or not required
  static Future<bool> requestMediaPermissions() async {
    if (!Platform.isAndroid) return true;

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      // Only needed for Android 13+
      if (androidInfo.version.sdkInt < 33) {
        return true;
      }

      // Request granular media permissions
      final Map<permission_handler.Permission, permission_handler.PermissionStatus> statuses = await [
        permission_handler.Permission.photos, // READ_MEDIA_IMAGES
        permission_handler.Permission.audio,  // READ_MEDIA_AUDIO
        // permission_handler.Permission.videos, // READ_MEDIA_VIDEO (commented out in manifest)
      ].request();

      final allGranted = statuses.values.every((status) => status.isGranted);

      if (kDebugMode) {
        print('$_tag: Media permissions ${allGranted ? 'granted' : 'denied'}');
        statuses.forEach((permission, status) {
          print('$_tag: ${permission.toString()} - ${status.toString()}');
        });
      }

      return allGranted;
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error requesting media permissions: $e');
      }
      return false;
    }
  }

  /// Get media permissions status for Android 13+
  static Future<Map<permission_handler.Permission, permission_handler.PermissionStatus>> getMediaPermissionsStatus() async {
    if (!Platform.isAndroid) {
      return {
        permission_handler.Permission.photos: permission_handler.PermissionStatus.granted,
        permission_handler.Permission.audio: permission_handler.PermissionStatus.granted,
      };
    }

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      // Only relevant for Android 13+
      if (androidInfo.version.sdkInt < 33) {
        return {
          permission_handler.Permission.photos: permission_handler.PermissionStatus.granted,
          permission_handler.Permission.audio: permission_handler.PermissionStatus.granted,
        };
      }

      return {
        permission_handler.Permission.photos: await permission_handler.Permission.photos.status,
        permission_handler.Permission.audio: await permission_handler.Permission.audio.status,
      };
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error checking media permissions status: $e');
      }
      return {
        permission_handler.Permission.photos: permission_handler.PermissionStatus.denied,
        permission_handler.Permission.audio: permission_handler.PermissionStatus.denied,
      };
    }
  }

  /// Request all essential permissions for file download functionality
  /// Returns true if all required permissions are granted
  static Future<bool> requestFileDownloadPermissions() async {
    try {
      if (kDebugMode) {
        print('$_tag: Requesting file download permissions...');
      }

      // Storage permission (for Android 12 and below)
      final storageGranted = await requestStoragePermission();
      if (!storageGranted) {
        if (kDebugMode) {
          print('$_tag: Storage permission required but not granted');
        }
        return false;
      }

      // Media permissions (for Android 13+)
      final mediaGranted = await requestMediaPermissions();
      if (!mediaGranted) {
        if (kDebugMode) {
          print('$_tag: Media permissions required but not granted');
        }
        // Don't fail for media permissions as they're not strictly required for downloads
        // but log the issue
      }

      // Notification permission (optional but recommended)
      final notificationGranted = await requestNotificationPermission();
      if (!notificationGranted) {
        if (kDebugMode) {
          print('$_tag: Notification permission not granted (optional)');
        }
      }

      if (kDebugMode) {
        print('$_tag: File download permissions setup completed');
      }

      return storageGranted; // Only require storage permission as essential
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error requesting file download permissions: $e');
      }
      return false;
    }
  }

  /// Check if all file download permissions are granted
  static Future<bool> hasFileDownloadPermissions() async {
    try {
      final storageStatus = await getStoragePermissionStatus();
      return storageStatus.isGranted;
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error checking file download permissions: $e');
      }
      return false;
    }
  }

  /// Open app settings for manual permission management
  static Future<bool> openAppSettings() async {
    try {
      return await permission_handler.openAppSettings();
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error opening app settings: $e');
      }
      return false;
    }
  }

  /// Get a comprehensive status of all app permissions
  static Future<Map<String, permission_handler.PermissionStatus>> getAllPermissionsStatus() async {
    try {
      final results = <String, permission_handler.PermissionStatus>{};

      results['storage'] = await getStoragePermissionStatus();
      results['notification'] = await getNotificationPermissionStatus();

      final mediaStatuses = await getMediaPermissionsStatus();
      results['photos'] = mediaStatuses[permission_handler.Permission.photos] ?? permission_handler.PermissionStatus.denied;
      results['audio'] = mediaStatuses[permission_handler.Permission.audio] ?? permission_handler.PermissionStatus.denied;

      return results;
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error getting all permissions status: $e');
      }
      return {};
    }
  }

  /// Check if the app has minimal permissions to function properly
  static Future<bool> hasMinimalPermissions() async {
    try {
      // At minimum, we need storage permission for core functionality
      return await hasFileDownloadPermissions();
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error checking minimal permissions: $e');
      }
      return false;
    }
  }

  /// Request permissions with user-friendly explanations
  static Future<PermissionRequestResult> requestPermissionsWithRationale({
    required List<PermissionType> permissions,
    String? customMessage,
  }) async {
    try {
      final results = <PermissionType, bool>{};
      final deniedPermissions = <PermissionType>[];

      for (final permissionType in permissions) {
        bool granted = false;

        switch (permissionType) {
          case PermissionType.storage:
            granted = await requestStoragePermission();
            break;
          case PermissionType.notification:
            granted = await requestNotificationPermission();
            break;
          case PermissionType.media:
            granted = await requestMediaPermissions();
            break;
        }

        results[permissionType] = granted;
        if (!granted) {
          deniedPermissions.add(permissionType);
        }
      }

      return PermissionRequestResult(
        results: results,
        allGranted: deniedPermissions.isEmpty,
        deniedPermissions: deniedPermissions,
        message: customMessage,
      );
    } catch (e) {
      if (kDebugMode) {
        print('$_tag: Error requesting permissions with rationale: $e');
      }
      return PermissionRequestResult(
        results: {},
        allGranted: false,
        deniedPermissions: permissions,
        message: 'Failed to request permissions: $e',
      );
    }
  }
}

/// Enum for different permission types in the app
enum PermissionType {
  storage,
  notification,
  media,
}

/// Result class for permission requests
class PermissionRequestResult {
  final Map<PermissionType, bool> results;
  final bool allGranted;
  final List<PermissionType> deniedPermissions;
  final String? message;

  const PermissionRequestResult({
    required this.results,
    required this.allGranted,
    required this.deniedPermissions,
    this.message,
  });

  /// Get user-friendly message about permission status
  String get statusMessage {
    if (allGranted) {
      return message ?? 'All permissions granted successfully!';
    }

    if (deniedPermissions.isEmpty) {
      return message ?? 'No permissions were requested.';
    }

    final deniedNames = deniedPermissions.map((p) {
      switch (p) {
        case PermissionType.storage:
          return 'Storage';
        case PermissionType.notification:
          return 'Notification';
        case PermissionType.media:
          return 'Media';
      }
    }).join(', ');

    return message ?? 'The following permissions were denied: $deniedNames. '
        'Some features may not work properly.';
  }

  /// Check if a specific permission was granted
  bool isGranted(PermissionType permission) {
    return results[permission] ?? false;
  }
}