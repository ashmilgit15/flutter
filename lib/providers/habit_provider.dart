import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';

/// Provider for managing habits and user profile state
class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];
  late UserProfile _profile;
  bool _isLoading = true;

  List<Habit> get habits => _habits;
  UserProfile get profile => _profile;
  bool get isLoading => _isLoading;

  /// Get active (non-wilted) habits
  List<Habit> get activeHabits => _habits.where((h) => !h.isWilted).toList();

  /// Get wilted habits
  List<Habit> get wiltedHabits => _habits.where((h) => h.isWilted).toList();

  /// Get completed habits today
  List<Habit> get completedToday =>
      _habits.where((h) => h.isCompletedToday).toList();

  /// Get pending habits today
  List<Habit> get pendingToday =>
      _habits.where((h) => !h.isCompletedToday).toList();

  /// Total sunlight earned today
  int get sunlightEarnedToday => completedToday.length * 5;

  /// Initialize provider
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    _habits = StorageService.getAllHabits();
    _profile = StorageService.getOrCreateProfile();

    // Check for wilted plants
    await _checkForWiltedPlants();

    _isLoading = false;
    notifyListeners();
  }

  /// Add new habit
  Future<void> addHabit({
    required String name,
    required String plantType,
    required String plantName,
    String? reminderTime,
  }) async {
    final habit = Habit(
      id: const Uuid().v4(),
      name: name,
      plantType: plantType,
      plantName: plantName,
      createdAt: DateTime.now(),
      reminderTime: reminderTime,
    );

    await StorageService.addHabit(habit);
    _habits.add(habit);

    // Schedule notification if enabled
    if (_profile.notificationsEnabled) {
      await NotificationService.scheduleSmartNotification(habit);
    }

    notifyListeners();
  }

  /// Update habit
  Future<void> updateHabit(Habit habit) async {
    await StorageService.updateHabit(habit);

    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
    }

    // Update notification
    if (_profile.notificationsEnabled) {
      await NotificationService.cancelNotification(habit.id.hashCode);
      await NotificationService.scheduleSmartNotification(habit);
    }

    notifyListeners();
  }

  /// Delete habit
  Future<void> deleteHabit(String id) async {
    await StorageService.deleteHabit(id);
    _habits.removeWhere((h) => h.id == id);

    // Cancel notification
    await NotificationService.cancelNotification(id.hashCode);

    notifyListeners();
  }

  /// Complete habit for today
  Future<void> completeHabit(String id) async {
    final habit = _habits.firstWhere((h) => h.id == id);

    if (habit.isCompletedToday) {
      return; // Already completed
    }

    // Complete the habit
    habit.complete();
    await StorageService.updateHabit(habit);

    // Award sunlight
    const sunlightReward = 5;
    _profile.earnSunlight(sunlightReward);
    _profile.totalHabitsCompleted++;
    await StorageService.updateProfile(_profile);

    // Play sound
    await AudioService.playWateringSound();

    // Check for streak milestones
    await NotificationService.scheduleStreakNotification(habit);

    notifyListeners();
  }

  /// Check for wilted plants
  Future<void> _checkForWiltedPlants() async {
    bool hasChanges = false;

    for (final habit in _habits) {
      if (habit.shouldWilt && !habit.isWilted) {
        habit.isWilted = true;
        habit.currentStreak = 0;
        await StorageService.updateHabit(habit);
        hasChanges = true;
      }
    }

    if (hasChanges) {
      notifyListeners();
    }
  }

  /// Revive a wilted plant (costs sunlight)
  Future<bool> revivePlant(String habitId) async {
    const reviveCost = 10;

    if (_profile.sunlight < reviveCost) {
      return false;
    }

    final habit = _habits.firstWhere((h) => h.id == habitId);
    habit.isWilted = false;
    habit.growthStage = 0; // Reset to seed
    await StorageService.updateHabit(habit);

    _profile.spendSunlight(reviveCost);
    await StorageService.updateProfile(_profile);

    notifyListeners();
    return true;
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    _profile.hasCompletedOnboarding = true;
    await StorageService.updateProfile(_profile);
    notifyListeners();
  }

  /// Unlock plant
  Future<bool> unlockPlant(String plantType, int cost) async {
    if (_profile.sunlight < cost) {
      return false;
    }

    _profile.unlockPlant(plantType, cost);
    await StorageService.updateProfile(_profile);
    notifyListeners();
    return true;
  }

  /// Unlock decoration
  Future<bool> unlockDecoration(String decoration, int cost) async {
    if (_profile.sunlight < cost) {
      return false;
    }

    _profile.unlockDecoration(decoration, cost);
    await StorageService.updateProfile(_profile);
    notifyListeners();
    return true;
  }

  /// Toggle sound
  Future<void> toggleSound() async {
    _profile.soundEnabled = !_profile.soundEnabled;
    AudioService.setSoundEnabled(_profile.soundEnabled);
    await StorageService.updateProfile(_profile);
    notifyListeners();
  }

  /// Toggle notifications
  Future<void> toggleNotifications() async {
    _profile.notificationsEnabled = !_profile.notificationsEnabled;

    if (_profile.notificationsEnabled) {
      // Request permission and schedule all
      final granted = await NotificationService.requestPermissions();
      if (granted) {
        for (final habit in _habits) {
          await NotificationService.scheduleSmartNotification(habit);
        }
      }
    } else {
      // Cancel all notifications
      await NotificationService.cancelAllNotifications();
    }

    await StorageService.updateProfile(_profile);
    notifyListeners();
  }

  /// Change theme
  Future<void> changeTheme(String theme) async {
    _profile.selectedTheme = theme;
    await StorageService.updateProfile(_profile);
    notifyListeners();
  }

  /// Award sunlight (for IAP)
  Future<void> awardSunlight(int amount) async {
    _profile.earnSunlight(amount);
    await StorageService.updateProfile(_profile);
    notifyListeners();
  }

  /// Get habit statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalHabits': _habits.length,
      'activeHabits': activeHabits.length,
      'completedToday': completedToday.length,
      'totalCompletions': _profile.totalHabitsCompleted,
      'currentSunlight': _profile.sunlight,
      'longestStreak': _habits.isEmpty
          ? 0
          : _habits.map((h) => h.longestStreak).reduce((a, b) => a > b ? a : b),
    };
  }
}
