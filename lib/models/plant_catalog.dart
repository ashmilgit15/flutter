/// Catalog of all available plants and their properties
class PlantInfo {
  final String id;
  final String name;
  final String emoji;
  final int unlockCost;
  final bool isStarter;
  final String description;

  const PlantInfo({
    required this.id,
    required this.name,
    required this.emoji,
    required this.unlockCost,
    this.isStarter = false,
    required this.description,
  });
}

/// All available plants in the game
class PlantCatalog {
  static const List<PlantInfo> allPlants = [
    // Starter plants (free)
    PlantInfo(
      id: 'fern',
      name: 'Peaceful Fern',
      emoji: '🌿',
      unlockCost: 0,
      isStarter: true,
      description: 'A calming fern that thrives with daily care',
    ),
    PlantInfo(
      id: 'cactus',
      name: 'Resilient Cactus',
      emoji: '🌵',
      unlockCost: 0,
      isStarter: true,
      description: 'Strong and steady, perfect for building habits',
    ),
    PlantInfo(
      id: 'sunflower',
      name: 'Bright Sunflower',
      emoji: '🌻',
      unlockCost: 0,
      isStarter: true,
      description: 'Brings sunshine to your daily routine',
    ),

    // Unlockable plants
    PlantInfo(
      id: 'rose',
      name: 'Elegant Rose',
      emoji: '🌹',
      unlockCost: 50,
      description: 'Beautiful blooms reward dedication',
    ),
    PlantInfo(
      id: 'tulip',
      name: 'Cheerful Tulip',
      emoji: '🌷',
      unlockCost: 50,
      description: 'Delicate petals for gentle habits',
    ),
    PlantInfo(
      id: 'cherry',
      name: 'Cherry Blossom',
      emoji: '🌸',
      unlockCost: 75,
      description: 'Fleeting beauty, lasting growth',
    ),
    PlantInfo(
      id: 'lotus',
      name: 'Serene Lotus',
      emoji: '🪷',
      unlockCost: 100,
      description: 'Peaceful wisdom through daily practice',
    ),
    PlantInfo(
      id: 'bamboo',
      name: 'Zen Bamboo',
      emoji: '🎋',
      unlockCost: 100,
      description: 'Flexibility and strength combined',
    ),
    PlantInfo(
      id: 'tree',
      name: 'Mighty Oak',
      emoji: '🌳',
      unlockCost: 150,
      description: 'From tiny seeds, great trees grow',
    ),
    PlantInfo(
      id: 'palm',
      name: 'Tropical Palm',
      emoji: '🌴',
      unlockCost: 125,
      description: 'Island vibes for island time',
    ),
  ];

  static const List<DecorationInfo> allDecorations = [
    DecorationInfo(
      id: 'stone_1',
      name: 'River Stone',
      emoji: '🪨',
      unlockCost: 30,
      description: 'A smooth stone for your garden',
    ),
    DecorationInfo(
      id: 'fountain',
      name: 'Water Fountain',
      emoji: '⛲',
      unlockCost: 80,
      description: 'Soothing water sounds',
    ),
    DecorationInfo(
      id: 'bench',
      name: 'Garden Bench',
      emoji: '🪑',
      unlockCost: 60,
      description: 'A place to rest and reflect',
    ),
    DecorationInfo(
      id: 'lantern',
      name: 'Paper Lantern',
      emoji: '🏮',
      unlockCost: 40,
      description: 'Gentle light for evening routines',
    ),
  ];

  /// Get plant info by ID
  static PlantInfo? getPlantById(String id) {
    try {
      return allPlants.firstWhere((plant) => plant.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get decoration info by ID
  static DecorationInfo? getDecorationById(String id) {
    try {
      return allDecorations.firstWhere((deco) => deco.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get starter plants
  static List<PlantInfo> get starterPlants {
    return allPlants.where((plant) => plant.isStarter).toList();
  }

  /// Get unlockable plants
  static List<PlantInfo> get unlockablePlants {
    return allPlants.where((plant) => !plant.isStarter).toList();
  }
}

class DecorationInfo {
  final String id;
  final String name;
  final String emoji;
  final int unlockCost;
  final String description;

  const DecorationInfo({
    required this.id,
    required this.name,
    required this.emoji,
    required this.unlockCost,
    required this.description,
  });
}
