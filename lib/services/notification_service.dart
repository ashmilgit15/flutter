import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/habit.dart';

/// Service for managing smart local notifications
/// Re-enabled with flutter_local_notifications ^17.2.2 and compatible timezone ^0.9.4
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  static Future<void> initialize() async {
    try {
      // Initialize notification settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings();

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(settings);
    } catch (e) {
      // Silently fail if notifications can't be initialized
      // This prevents app crashes on devices that don't support notifications
    }
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        return await androidPlugin.requestNotificationsPermission() ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Schedule smart notification for a habit
  static Future<void> scheduleSmartNotification(Habit habit) async {
    try {
      // Only schedule if habit has a reminder time and is not wilted
      if (habit.reminderTime == null || habit.isWilted) return;

      // Parse reminder time (format: "HH:mm")
      final timeParts = habit.reminderTime!.split(':');
      if (timeParts.length != 2) return;

      final reminderHour = int.tryParse(timeParts[0]);
      final reminderMinute = int.tryParse(timeParts[1]);
      if (reminderHour == null || reminderMinute == null) return;

      final now = tz.TZDateTime.now(tz.local);
      final scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        reminderHour,
        reminderMinute,
      );

      // If the time has passed today, schedule for tomorrow
      final notificationTime = scheduledTime.isBefore(now)
          ? scheduledTime.add(const Duration(days: 1))
          : scheduledTime;

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'habit_reminders',
        'Habit Reminders',
        channelDescription: 'Daily reminders to complete your habits',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Convert string id to int hash for notification id
      final notificationId = habit.id.hashCode.abs();

      await _notifications.zonedSchedule(
        notificationId,
        'Habit Reminder',
        'Don\'t forget to complete: ${habit.name}',
        notificationTime,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      // Silently fail if scheduling fails
    }
  }

  /// Cancel notification for a habit
  static Future<void> cancelNotification(String habitId) async {
    try {
      final notificationId = habitId.hashCode.abs();
      await _notifications.cancel(notificationId);
    } catch (e) {
      // Silently fail if cancellation fails
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
    } catch (e) {
      // Silently fail if cancellation fails
    }
  }

  /// Show immediate notification (for testing or achievements)
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'habit_achievements',
        'Habit Achievements',
        channelDescription: 'Celebrate your habit milestones',
        importance: Importance.high,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(id, title, body, details);
    } catch (e) {
      // Silently fail if notification fails
    }
  }

  /// Schedule encouraging notification for streak milestones
  static Future<void> scheduleStreakNotification(Habit habit) async {
    try {
      if (habit.currentStreak > 0 && habit.currentStreak % 7 == 0) {
        // Show achievement notification for weekly milestones
        final notificationId = '${habit.id}_streak'.hashCode.abs();
        await showNotification(
          id: notificationId,
          title: '🌟 Amazing Streak!',
          body: 'You\'ve completed ${habit.name} for ${habit.currentStreak} days!',
        );
      }
    } catch (e) {
      // Silently fail if notification fails
    }
  }
}
