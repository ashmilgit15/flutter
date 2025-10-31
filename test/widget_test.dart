// Habit Garden unit tests

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_garden/models/habit.dart';
import 'package:habit_garden/models/plant_catalog.dart';

void main() {
  group('Habit Model Tests', () {
    test('Habit creation with required fields', () {
      final now = DateTime.now();
      final habit = Habit(
        id: '1',
        name: 'Morning Exercise',
        plantType: 'fern',
        plantName: 'My Fern',
        createdAt: now,
      );

      expect(habit.id, '1');
      expect(habit.name, 'Morning Exercise');
      expect(habit.plantType, 'fern');
      expect(habit.plantName, 'My Fern');
      expect(habit.currentStreak, 0);
      expect(habit.growthStage, 0);
      expect(habit.isWilted, false);
    });

    test('Habit tracks completion status', () {
      final now = DateTime.now();
      final habit = Habit(
        id: '1',
        name: 'Reading',
        plantType: 'cactus',
        plantName: 'Spike',
        createdAt: now,
        lastCompletedAt: now,
      );

      expect(habit.isCompletedToday, true);
    });

    test('Habit growth percentage calculation', () {
      final habit = Habit(
        id: '1',
        name: 'Meditation',
        plantType: 'sunflower',
        plantName: 'Sunny',
        createdAt: DateTime.now(),
        growthStage: 0,
      );

      expect(habit.growthPercentage, 0);

      // Test growth percentage at different stages
      habit.growthStage = 1;
      expect(habit.growthPercentage, closeTo(33.33, 0.01));

      habit.growthStage = 3;
      expect(habit.growthPercentage, 100);
    });

    test('Habit wilting detection', () {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      final habit = Habit(
        id: '1',
        name: 'Exercise',
        plantType: 'rose',
        plantName: 'Rose Garden',
        createdAt: threeDaysAgo,
        lastCompletedAt: threeDaysAgo,
      );

      // Habit should wilt if not completed in a while
      expect(habit.shouldWilt, true);
    });
  });

  group('Plant Catalog Tests', () {
    test('Plant catalog has multiple plants', () {
      final plants = PlantCatalog.allPlants;
      
      expect(plants, isNotEmpty);
      expect(plants.length, greaterThanOrEqualTo(5));
    });

    test('Plant catalog has starter plants', () {
      final starterPlants = PlantCatalog.starterPlants;
      
      expect(starterPlants, isNotEmpty);
      expect(starterPlants.every((plant) => plant.isStarter), true);
      expect(starterPlants.every((plant) => plant.unlockCost == 0), true);
    });

    test('Plant catalog entries have valid properties', () {
      final plants = PlantCatalog.allPlants;
      
      for (final plant in plants) {
        expect(plant.id, isNotEmpty);
        expect(plant.name, isNotEmpty);
        expect(plant.emoji, isNotEmpty);
        expect(plant.unlockCost, greaterThanOrEqualTo(0));
        expect(plant.description, isNotEmpty);
      }
    });

    test('Get plant by ID works correctly', () {
      final fern = PlantCatalog.getPlantById('fern');
      expect(fern, isNotNull);
      expect(fern?.name, 'Peaceful Fern');
      expect(fern?.emoji, '🌿');

      final nonExistent = PlantCatalog.getPlantById('nonexistent');
      expect(nonExistent, isNull);
    });

    test('Decoration catalog has entries', () {
      final decorations = PlantCatalog.allDecorations;
      
      expect(decorations, isNotEmpty);
      for (final deco in decorations) {
        expect(deco.id, isNotEmpty);
        expect(deco.name, isNotEmpty);
        expect(deco.emoji, isNotEmpty);
      }
    });
  });
}
