import 'package:flutter/material.dart';
import '../models/habit.dart';

/// Animated plant widget that shows growth stages
class PlantWidget extends StatefulWidget {
  final Habit habit;
  final double size;
  final VoidCallback? onTap;

  const PlantWidget({
    Key? key,
    required this.habit,
    this.size = 100,
    this.onTap,
  }) : super(key: key);

  @override
  State<PlantWidget> createState() => _PlantWidgetState();
}

class _PlantWidgetState extends State<PlantWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: -0.02, end: 0.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getPlantEmoji() {
    // Get base plant emoji based on type and growth stage
    final baseEmoji = _getBaseEmoji();
    
    if (widget.habit.isWilted) {
      return '🥀'; // Wilted flower
    }
    
    return baseEmoji;
  }

  String _getBaseEmoji() {
    final type = widget.habit.plantType;
    final stage = widget.habit.growthStage;

    // Growth stages: 0: seed, 1: sprout, 2: bloom, 3: full plant
    if (stage == 0) {
      return '🌱'; // Seed/sprout for all
    }

    switch (type) {
      case 'fern':
        if (stage == 1) return '🌿';
        if (stage == 2) return '🪴';
        return '🌿';
      case 'cactus':
        if (stage == 1) return '🌵';
        if (stage == 2) return '🌵';
        return '🌵';
      case 'sunflower':
        if (stage == 1) return '🌻';
        if (stage == 2) return '🌻';
        return '🌻';
      case 'rose':
        if (stage == 1) return '🌹';
        if (stage == 2) return '🌹';
        return '🌹';
      case 'tulip':
        if (stage == 1) return '🌷';
        if (stage == 2) return '🌷';
        return '🌷';
      case 'cherry':
        if (stage == 1) return '🌸';
        if (stage == 2) return '🌸';
        return '🌸';
      case 'lotus':
        if (stage == 1) return '🪷';
        if (stage == 2) return '🪷';
        return '🪷';
      case 'bamboo':
        if (stage == 1) return '🎋';
        if (stage == 2) return '🎋';
        return '🎋';
      case 'tree':
        if (stage == 1) return '🌳';
        if (stage == 2) return '🌳';
        return '🌳';
      case 'palm':
        if (stage == 1) return '🌴';
        if (stage == 2) return '🌴';
        return '🌴';
      default:
        return '🌱';
    }
  }

  double _getOpacity() {
    if (widget.habit.isWilted) return 0.5;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Opacity(
                opacity: _getOpacity(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Plant emoji
                    Text(
                      _getPlantEmoji(),
                      style: TextStyle(fontSize: widget.size),
                    ),
                    
                    // Growth indicator
                    const SizedBox(height: 8),
                    Container(
                      width: widget.size * 0.8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: widget.habit.growthPercentage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.habit.isWilted
                                ? Colors.red[300]
                                : Colors.green[400],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    
                    // Plant name
                    const SizedBox(height: 4),
                    Text(
                      widget.habit.plantName,
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.habit.isWilted
                            ? Colors.grey
                            : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    // Streak indicator
                    if (widget.habit.currentStreak > 0 && !widget.habit.isWilted)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '🔥 ${widget.habit.currentStreak}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
