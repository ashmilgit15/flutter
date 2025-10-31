import 'package:hive/hive.dart';

part 'user_profile.g.dart';

/// Represents user's profile with currency and unlocks
@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  @HiveField(0)
  int sunlight; // In-game currency

  @HiveField(1)
  List<String> unlockedPlants;

  @HiveField(2)
  List<String> unlockedDecorations;

  @HiveField(3)
  bool hasCompletedOnboarding;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  String selectedTheme; // 'spring', 'summer', 'autumn', 'winter'

  @HiveField(6)
  bool soundEnabled;

  @HiveField(7)
  bool notificationsEnabled;

  @HiveField(8)
  int totalHabitsCompleted;

  @HiveField(9)
  int consecutiveDaysActive;

  UserProfile({
    this.sunlight = 0,
    List<String>? unlockedPlants,
    List<String>? unlockedDecorations,
    this.hasCompletedOnboarding = false,
    DateTime? createdAt,
    this.selectedTheme = 'spring',
    this.soundEnabled = true,
    this.notificationsEnabled = true,
    this.totalHabitsCompleted = 0,
    this.consecutiveDaysActive = 0,
  }) : unlockedPlants = unlockedPlants ?? ['fern', 'cactus', 'sunflower'],
       unlockedDecorations = unlockedDecorations ?? [],
       createdAt = createdAt ?? DateTime.now();

  /// Award sunlight for completing a habit
  void earnSunlight(int amount) {
    sunlight += amount;
    save();
  }

  /// Spend sunlight on unlocks
  bool spendSunlight(int amount) {
    if (sunlight >= amount) {
      sunlight -= amount;
      save();
      return true;
    }
    return false;
  }

  /// Unlock a new plant type
  void unlockPlant(String plantType, int cost) {
    if (!unlockedPlants.contains(plantType) && spendSunlight(cost)) {
      unlockedPlants.add(plantType);
      save();
    }
  }

  /// Unlock a decoration
  void unlockDecoration(String decoration, int cost) {
    if (!unlockedDecorations.contains(decoration) && spendSunlight(cost)) {
      unlockedDecorations.add(decoration);
      save();
    }
  }

  /// Check if plant is unlocked
  bool isPlantUnlocked(String plantType) {
    return unlockedPlants.contains(plantType);
  }

  /// Check if decoration is unlocked
  bool isDecorationUnlocked(String decoration) {
    return unlockedDecorations.contains(decoration);
  }
}
