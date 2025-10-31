import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/habit.dart';

/// Service for managing smart local notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification service
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle navigation to specific habit if needed
    // This can be expanded to navigate to specific habit screen
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final iosPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    bool granted = true;

    if (androidPlugin != null) {
      granted = await androidPlugin.requestNotificationsPermission() ?? false;
    }

    if (iosPlugin != null) {
      granted =
          await iosPlugin.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    return granted;
  }

  /// Schedule smart notification for a habit
  static Future<void> scheduleSmartNotification(Habit habit) async {
    // Determine best time to remind based on habit history
    String? reminderTime =
        habit.reminderTime ?? habit.suggestedReminderTime ?? '09:00';

    final timeParts = reminderTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    await _scheduleNotification(
      id: habit.id.hashCode,
      title: '${habit.plantName} is waiting! 🌱',
      body: 'Time for "${habit.name}" - Your ${habit.plantType} needs you',
      hour: hour,
      minute: minute,
    );
  }

  /// Schedule a daily notification
  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminders',
          'Habit Reminders',
          channelDescription: 'Daily reminders for your habits',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Calculate next instance of given time
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// Cancel notification for a habit
  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Show immediate notification (for testing or achievements)
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_alerts',
          'Habit Alerts',
          channelDescription: 'Alerts for habit achievements',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  /// Schedule encouraging notification for streak milestones
  static Future<void> scheduleStreakNotification(Habit habit) async {
    if (habit.currentStreak == 7) {
      await showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: '🎉 Week Streak!',
        body: 'Your ${habit.plantName} is sprouting! Keep it up!',
      );
    } else if (habit.currentStreak == 14) {
      await showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: '🌸 Two Weeks!',
        body: 'Your ${habit.plantName} is blooming beautifully!',
      );
    } else if (habit.currentStreak == 21) {
      await showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: '🌳 Three Weeks!',
        body: 'Your ${habit.plantName} has reached full maturity!',
      );
    }
  }
}
