import 'package:hive/hive.dart';

part 'habit.g.dart';

/// Represents a user's habit with associated plant and tracking data
@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String plantType; // e.g., 'fern', 'cactus', 'sunflower', 'rose', 'bamboo'

  @HiveField(3)
  String plantName; // User-given name for their plant

  @HiveField(4)
  int growthStage; // 0: seed, 1: sprout, 2: bloom, 3: full plant

  @HiveField(5)
  int currentStreak;

  @HiveField(6)
  int longestStreak;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? lastCompletedAt;

  @HiveField(9)
  List<DateTime> completionHistory;

  @HiveField(10)
  bool isWilted; // True if habit was missed

  @HiveField(11)
  int totalCompletions;

  @HiveField(12)
  String? reminderTime; // Format: "HH:mm"

  @HiveField(13)
  List<int> smartReminderTimes; // Minutes from midnight when habit was completed

  Habit({
    required this.id,
    required this.name,
    required this.plantType,
    required this.plantName,
    this.growthStage = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.createdAt,
    this.lastCompletedAt,
    List<DateTime>? completionHistory,
    this.isWilted = false,
    this.totalCompletions = 0,
    this.reminderTime,
    List<int>? smartReminderTimes,
  })  : completionHistory = completionHistory ?? [],
        smartReminderTimes = smartReminderTimes ?? [];

  /// Check if habit was completed today
  bool get isCompletedToday {
    if (lastCompletedAt == null) return false;
    final now = DateTime.now();
    return lastCompletedAt!.year == now.year &&
        lastCompletedAt!.month == now.month &&
        lastCompletedAt!.day == now.day;
  }

  /// Check if habit should wilt (missed yesterday)
  bool get shouldWilt {
    if (lastCompletedAt == null && createdAt.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return true;
    }
    if (lastCompletedAt == null) return false;
    
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return lastCompletedAt!.isBefore(DateTime(yesterday.year, yesterday.month, yesterday.day));
  }

  /// Get growth percentage (0-100)
  double get growthPercentage {
    return (growthStage / 3.0) * 100.0;
  }

  /// Complete habit for today
  void complete() {
    final now = DateTime.now();
    
    // Check if already completed today
    if (isCompletedToday) return;

    // Update completion tracking
    lastCompletedAt = now;
    completionHistory.add(now);
    totalCompletions++;

    // Update streak
    final yesterday = now.subtract(const Duration(days: 1));
    final lastWasYesterday = lastCompletedAt != null &&
        lastCompletedAt!.year == yesterday.year &&
        lastCompletedAt!.month == yesterday.month &&
        lastCompletedAt!.day == yesterday.day;

    if (lastWasYesterday || currentStreak == 0) {
      currentStreak++;
    } else {
      currentStreak = 1;
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    // Update growth stage based on streak milestones
    if (currentStreak >= 21 && growthStage < 3) {
      growthStage = 3; // Full plant
    } else if (currentStreak >= 14 && growthStage < 2) {
      growthStage = 2; // Bloom
    } else if (currentStreak >= 7 && growthStage < 1) {
      growthStage = 1; // Sprout
    }

    // No longer wilted
    isWilted = false;

    // Track smart reminder time (minutes from midnight)
    final minutesFromMidnight = now.hour * 60 + now.minute;
    smartReminderTimes.add(minutesFromMidnight);
    
    // Keep only last 30 completion times for smart reminders
    if (smartReminderTimes.length > 30) {
      smartReminderTimes.removeAt(0);
    }

    save();
  }

  /// Calculate average completion time for smart notifications
  int? get averageCompletionTime {
    if (smartReminderTimes.isEmpty) return null;
    final sum = smartReminderTimes.reduce((a, b) => a + b);
    return sum ~/ smartReminderTimes.length;
  }

  /// Get suggested reminder time
  String? get suggestedReminderTime {
    final avgTime = averageCompletionTime;
    if (avgTime == null) return null;
    
    final hours = avgTime ~/ 60;
    final minutes = avgTime % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
