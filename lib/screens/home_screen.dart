/// HOME SCREEN - Main App Interface
///
/// FIXES APPLIED:
/// - ✅ Resolved const constructor conflicts in widget tree
/// - ✅ Proper const optimization without breaking dynamic content
///
/// OPTIMIZATIONS:
/// - ✅ Added const constructors to stateless widgets
/// - ✅ Optimized IndexedStack for tab switching
/// - ✅ Efficient Consumer usage for state updates
///
/// FEATURES:
/// - Garden view with plant grid
/// - Habits list with completion tracking
/// - Shop and settings tabs

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/plant_widget.dart';
import '../utils/theme.dart';
import 'add_habit_screen.dart';
import 'settings_screen.dart';
import 'shop_screen.dart';

/// Main home screen showing the garden view
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          GardenView(),
          HabitsListView(),
          ShopScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.park), label: 'Garden'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Habits'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddHabitScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

/// Garden view showing all plants
class GardenView extends StatelessWidget {
  const GardenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final habits = provider.habits;
        final profile = provider.profile;

        return Container(
          decoration: BoxDecoration(
            gradient: AppTheme.getGradient(profile.selectedTheme),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Garden',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getGreeting(),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.textLight),
                          ),
                        ],
                      ),
                      // Sunlight counter
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text('☀️', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              '${profile.sunlight}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                        '${provider.completedToday.length}/${habits.length}',
                        'Today',
                      ),
                      Container(width: 1, height: 30, color: Colors.grey[300]),
                      _buildStatColumn(
                        '${provider.activeHabits.length}',
                        'Active',
                      ),
                      Container(width: 1, height: 30, color: Colors.grey[300]),
                      _buildStatColumn(
                        '${profile.totalHabitsCompleted}',
                        'Total',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Garden grid
                Expanded(
                  child: habits.isEmpty
                      ? _buildEmptyGarden(context)
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: habits.length,
                          itemBuilder: (context, index) {
                            final habit = habits[index];
                            return PlantWidget(
                              habit: habit,
                              size: 80,
                              onTap: () {
                                _showHabitDetails(context, habit);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
        ),
      ],
    );
  }

  Widget _buildEmptyGarden(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          Text(
            'Your garden is empty',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first habit to start growing',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textLight),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddHabitScreen()),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Habit'),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning! 🌤️';
    if (hour < 17) return 'Good afternoon! ☀️';
    return 'Good evening! 🌙';
  }

  void _showHabitDetails(BuildContext context, habit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<HabitProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    habit.plantName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    habit.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailItem(
                        '🔥',
                        '${habit.currentStreak}',
                        'Streak',
                      ),
                      _buildDetailItem('🏆', '${habit.longestStreak}', 'Best'),
                      _buildDetailItem(
                        '✅',
                        '${habit.totalCompletions}',
                        'Total',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (!habit.isCompletedToday && !habit.isWilted)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          provider.completeHabit(habit.id);
                          Navigator.of(context).pop();
                        },
                        child: const Text('Complete Habit'),
                      ),
                    ),
                  if (habit.isWilted)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await provider.revivePlant(habit.id);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Plant revived! 🌱'
                                      : 'Not enough sunlight ☀️',
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Revive Plant (10 ☀️)'),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
        ),
      ],
    );
  }
}

/// List view of habits
class HabitsListView extends StatelessWidget {
  const HabitsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final habits = provider.habits;

        return Container(
          decoration: BoxDecoration(
            gradient: AppTheme.getGradient(provider.profile.selectedTheme),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'My Habits',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: habits.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('📝', style: TextStyle(fontSize: 80)),
                              const SizedBox(height: 16),
                              Text(
                                'No habits yet',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: habits.length,
                          itemBuilder: (context, index) {
                            final habit = habits[index];
                            return _buildHabitListItem(
                              context,
                              habit,
                              provider,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHabitListItem(
    BuildContext context,
    Habit habit,
    HabitProvider provider,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Text(
          habit.isWilted
              ? '🥀'
              : habit.isCompletedToday
              ? '✅'
              : '⭕',
          style: const TextStyle(fontSize: 32),
        ),
        title: Text(habit.name),
        subtitle: Text(
          '${habit.plantName} • ${habit.currentStreak} day streak',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showOptions(context, habit, provider);
          },
        ),
        onTap: habit.isCompletedToday
            ? null
            : () {
                provider.completeHabit(habit.id);
              },
      ),
    );
  }

  void _showOptions(BuildContext context, Habit habit, HabitProvider provider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddHabitScreen(habit: habit),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, habit, provider);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    Habit habit,
    HabitProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Habit'),
          content: Text('Are you sure you want to delete "${habit.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.deleteHabit(habit.id);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
