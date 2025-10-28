import 'package:hive_flutter/hive_flutter.dart';
import '../models/habit.dart';
import '../models/user_profile.dart';

/// Service for managing local data storage with Hive
class StorageService {
  static const String _habitsBoxName = 'habits';
  static const String _profileBoxName = 'profile';

  /// Initialize Hive and open boxes
  static Future<void> initialize() async {
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(UserProfileAdapter());

    // Open boxes
    await Hive.openBox<Habit>(_habitsBoxName);
    await Hive.openBox<UserProfile>(_profileBoxName);
  }

  /// Get habits box
  static Box<Habit> get habitsBox => Hive.box<Habit>(_habitsBoxName);

  /// Get profile box
  static Box<UserProfile> get profileBox => Hive.box<UserProfile>(_profileBoxName);

  /// Get or create user profile
  static UserProfile getOrCreateProfile() {
    if (profileBox.isEmpty) {
      final profile = UserProfile();
      profileBox.put('profile', profile);
      return profile;
    }
    return profileBox.get('profile')!;
  }

  /// Get all habits
  static List<Habit> getAllHabits() {
    return habitsBox.values.toList();
  }

  /// Get habit by ID
  static Habit? getHabitById(String id) {
    return habitsBox.values.firstWhere(
      (habit) => habit.id == id,
      orElse: () => throw Exception('Habit not found'),
    );
  }

  /// Add new habit
  static Future<void> addHabit(Habit habit) async {
    await habitsBox.put(habit.id, habit);
  }

  /// Update habit
  static Future<void> updateHabit(Habit habit) async {
    await habit.save();
  }

  /// Delete habit
  static Future<void> deleteHabit(String id) async {
    await habitsBox.delete(id);
  }

  /// Update user profile
  static Future<void> updateProfile(UserProfile profile) async {
    await profile.save();
  }

  /// Clear all data (for testing)
  static Future<void> clearAll() async {
    await habitsBox.clear();
    await profileBox.clear();
  }

  /// Close all boxes
  static Future<void> close() async {
    await habitsBox.close();
    await profileBox.close();
  }
}
