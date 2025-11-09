import '../models/habit.dart';

/// Service for managing smart local notifications
/// NOTE: Temporarily disabled to fix Android build issue with flutter_local_notifications
///
/// The issue was: bigPictureStyle.bigLargeIcon(null) - ambiguous method call between Bitmap and Icon
/// To re-enable notifications:
/// 1. Use flutter_local_notifications: ^16.3.2 (known working version)
/// 2. Or use awesome_notifications package as alternative
/// 3. Or wait for official fix in newer versions
class NotificationService {
  /// Initialize notification service
  static Future<void> initialize() async {
    // Notifications temporarily disabled to fix build issue
    // TODO: Re-enable when flutter_local_notifications build issue is resolved
    print('Notifications disabled - build issue with flutter_local_notifications');
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    // Notifications disabled - return false
    return false;
  }

  /// Schedule smart notification for a habit
  static Future<void> scheduleSmartNotification(Habit habit) async {
    // Notifications disabled
  }

  /// Cancel notification for a habit
  static Future<void> cancelNotification(int id) async {
    // Notifications disabled
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    // Notifications disabled
  }

  /// Show immediate notification (for testing or achievements)
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // Notifications disabled
  }

  /// Schedule encouraging notification for streak milestones
  static Future<void> scheduleStreakNotification(Habit habit) async {
    // Notifications disabled
  }
}
