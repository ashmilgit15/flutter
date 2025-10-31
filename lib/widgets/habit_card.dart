import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../utils/theme.dart';

/// Card displaying habit information with completion button
class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompletedToday;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: isCompleted ? null : onComplete,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Plant emoji
              Text(_getPlantEmoji(), style: const TextStyle(fontSize: 40)),

              const SizedBox(width: 16),

              // Habit info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.plantName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: habit.growthPercentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          habit.isWilted
                              ? AppTheme.errorRed
                              : AppTheme.successGreen,
                        ),
                        minHeight: 6,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Stats row
                    Row(
                      children: [
                        if (habit.currentStreak > 0 && !habit.isWilted)
                          _buildStatChip(
                            '🔥 ${habit.currentStreak} day streak',
                            Colors.orange[100]!,
                          ),
                        const SizedBox(width: 8),
                        _buildStatChip(
                          'Stage ${habit.growthStage + 1}/4',
                          AppTheme.paleGreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Completion button or checkmark
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: AppTheme.successGreen,
                  size: 40,
                )
              else
                IconButton(
                  onPressed: onComplete,
                  icon: const Icon(Icons.circle_outlined, size: 40),
                  color: AppTheme.primaryGreen,
                ),

              // More options
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit' && onEdit != null) {
                      onEdit!();
                    } else if (value == 'delete' && onDelete != null) {
                      onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    if (onEdit != null)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    if (onDelete != null)
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _getPlantEmoji() {
    if (habit.isWilted) return '🥀';

    switch (habit.plantType) {
      case 'fern':
        return '🌿';
      case 'cactus':
        return '🌵';
      case 'sunflower':
        return '🌻';
      case 'rose':
        return '🌹';
      case 'tulip':
        return '🌷';
      case 'cherry':
        return '🌸';
      case 'lotus':
        return '🪷';
      case 'bamboo':
        return '🎋';
      case 'tree':
        return '🌳';
      case 'palm':
        return '🌴';
      default:
        return '🌱';
    }
  }
}
