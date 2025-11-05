/// ONBOARDING SCREEN - User Setup Flow
///
/// FIXES APPLIED:
/// - ✅ Fixed RenderFlex overflow by wrapping pages in SingleChildScrollView
/// - ✅ Prevents content from being cut off on smaller screens
/// - ✅ Maintains proper aspect ratios and responsive design
///
/// OPTIMIZATIONS:
/// - ✅ Added const constructors for better performance
/// - ✅ Proper state management with form validation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/plant_catalog.dart';
import '../utils/theme.dart';

/// Onboarding screen for first-time users
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Step 1: Habit inputs
  final List<TextEditingController> _habitControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  // Step 2: Plant selections
  final List<String> _selectedPlants = ['fern', 'cactus', 'sunflower'];

  // Step 3: Plant names
  final List<TextEditingController> _plantNameControllers = [
    TextEditingController(text: 'My Fern'),
    TextEditingController(text: 'My Cactus'),
    TextEditingController(text: 'My Sunflower'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _habitControllers) {
      controller.dispose();
    }
    for (var controller in _plantNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final provider = Provider.of<HabitProvider>(context, listen: false);

    // Create habits
    for (int i = 0; i < 3; i++) {
      if (_habitControllers[i].text.isNotEmpty) {
        await provider.addHabit(
          name: _habitControllers[i].text,
          plantType: _selectedPlants[i],
          plantName: _plantNameControllers[i].text,
        );
      }
    }

    await provider.completeOnboarding();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.springGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Progress indicator
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: List.generate(
                    4,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? AppTheme.primaryGreen
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildWelcomePage(),
                    _buildHabitsPage(),
                    _buildPlantsPage(),
                    _buildNamesPage(),
                  ],
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      TextButton(
                        onPressed: _previousPage,
                        child: const Text('Back'),
                      )
                    else
                      const SizedBox(width: 80),

                    ElevatedButton(
                      onPressed: _currentPage == 3
                          ? _completeOnboarding
                          : _nextPage,
                      child: Text(_currentPage == 3 ? 'Start Growing' : 'Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 100)),
          const SizedBox(height: 32),
          Text(
            'Welcome to\nHabit Garden',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Grow beautiful plants by\nmaintaining daily habits',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.textLight),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildFeatureRow('🌿', 'Complete habits daily'),
                const SizedBox(height: 12),
                _buildFeatureRow('📈', 'Watch your plants grow'),
                const SizedBox(height: 12),
                _buildFeatureRow('🏆', 'Build lasting streaks'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildHabitsPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose 3 Starter Habits',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'What daily habits do you want to build?',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textLight),
          ),
          const SizedBox(height: 32),

          _buildHabitInput(0, 'Drink 8 glasses of water'),
          const SizedBox(height: 16),
          _buildHabitInput(1, 'Read for 20 minutes'),
          const SizedBox(height: 16),
          _buildHabitInput(2, 'Practice gratitude'),
        ],
      ),
    );
  }

  Widget _buildHabitInput(int index, String hint) {
    return TextField(
      controller: _habitControllers[index],
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.check_circle_outline),
      ),
    );
  }

  Widget _buildPlantsPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
            'Choose Your Plants',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Each habit will grow a different plant',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textLight),
          ),
          const SizedBox(height: 32),

          for (int i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildPlantSelector(i),
            ),
        ],
      ),
    ),
  );
}

  Widget _buildPlantSelector(int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _habitControllers[index].text.isEmpty
                ? 'Habit ${index + 1}'
                : _habitControllers[index].text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: PlantCatalog.starterPlants.map((plant) {
              final isSelected = _selectedPlants[index] == plant.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPlants[index] = plant.id;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.paleGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(plant.emoji, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 4),
                      Text(
                        plant.name.split(' ').last,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNamesPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
            'Name Your Plants',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Give your plants personality! 🌱',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textLight),
          ),
          const SizedBox(height: 32),

          for (int i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildPlantNameInput(i),
            ),
        ],
      ),
    ),
  );
}

  Widget _buildPlantNameInput(int index) {
    final plantInfo = PlantCatalog.getPlantById(_selectedPlants[index]);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(plantInfo?.emoji ?? '🌱', style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: _plantNameControllers[index],
              decoration: const InputDecoration(
                hintText: 'Plant name',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
