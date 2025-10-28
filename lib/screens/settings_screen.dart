import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../utils/theme.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        final profile = provider.profile;
        final stats = provider.getStatistics();

        return Container(
          decoration: BoxDecoration(
            gradient: AppTheme.getGradient(profile.selectedTheme),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 24),

                // Statistics card
                _buildCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('📊', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 12),
                          Text(
                            'Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow('Total Habits', '${stats['totalHabits']}'),
                      _buildStatRow('Active Habits', '${stats['activeHabits']}'),
                      _buildStatRow(
                          'Completed Today', '${stats['completedToday']}'),
                      _buildStatRow('Total Completions',
                          '${stats['totalCompletions']}'),
                      _buildStatRow(
                          'Longest Streak', '${stats['longestStreak']} days'),
                      _buildStatRow(
                          'Current Sunlight', '${stats['currentSunlight']} ☀️'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Theme selection
                _buildCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('🎨', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 12),
                          Text(
                            'Garden Theme',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildThemeOption(
                            context,
                            'Spring',
                            '🌸',
                            'spring',
                            profile.selectedTheme == 'spring',
                            provider,
                          ),
                          _buildThemeOption(
                            context,
                            'Summer',
                            '☀️',
                            'summer',
                            profile.selectedTheme == 'summer',
                            provider,
                          ),
                          _buildThemeOption(
                            context,
                            'Autumn',
                            '🍂',
                            'autumn',
                            profile.selectedTheme == 'autumn',
                            provider,
                          ),
                          _buildThemeOption(
                            context,
                            'Winter',
                            '❄️',
                            'winter',
                            profile.selectedTheme == 'winter',
                            provider,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Preferences
                _buildCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('⚙️', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 12),
                          Text(
                            'Preferences',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Sound Effects'),
                        subtitle: const Text('Play soothing sounds'),
                        value: profile.soundEnabled,
                        onChanged: (value) {
                          provider.toggleSound();
                        },
                        activeColor: AppTheme.primaryGreen,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const Divider(),
                      SwitchListTile(
                        title: const Text('Smart Notifications'),
                        subtitle: const Text('Daily habit reminders'),
                        value: profile.notificationsEnabled,
                        onChanged: (value) {
                          provider.toggleNotifications();
                        },
                        activeColor: AppTheme.primaryGreen,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // About
                _buildCard(
                  context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text('ℹ️', style: TextStyle(fontSize: 24)),
                          SizedBox(width: 12),
                          Text(
                            'About',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Habit Garden',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'A calming, gamified habit tracker where you grow a virtual garden by maintaining daily habits.',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Text('Made with 💚 and Flutter'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textLight),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String name,
    String emoji,
    String themeId,
    bool isSelected,
    HabitProvider provider,
  ) {
    return GestureDetector(
      onTap: () {
        provider.changeTheme(themeId);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.paleGreen : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppTheme.primaryGreen : AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
