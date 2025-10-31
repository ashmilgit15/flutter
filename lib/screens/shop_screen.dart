import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/plant_catalog.dart';
import '../utils/theme.dart';

/// Shop screen for unlocking plants and decorations
class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: AppTheme.getGradient(provider.profile.selectedTheme),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shop',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Text('☀️',
                                      style: TextStyle(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${provider.profile.sunlight}',
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
                        const SizedBox(height: 8),
                        Text(
                          'Unlock new plants and decorations',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textLight,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Plants section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      '🌱 Plants',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final plant = PlantCatalog.unlockablePlants[index];
                        final isUnlocked =
                            provider.profile.isPlantUnlocked(plant.id);
                        final canAfford =
                            provider.profile.sunlight >= plant.unlockCost;

                        return _buildShopItem(
                          context: context,
                          emoji: plant.emoji,
                          name: plant.name,
                          description: plant.description,
                          cost: plant.unlockCost,
                          isUnlocked: isUnlocked,
                          canAfford: canAfford,
                          onUnlock: () async {
                            final success = await provider.unlockPlant(
                              plant.id,
                              plant.unlockCost,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? '${plant.name} unlocked! 🎉'
                                      : 'Not enough sunlight ☀️'),
                                ),
                              );
                            }
                          },
                        );
                      },
                      childCount: PlantCatalog.unlockablePlants.length,
                    ),
                  ),
                ),

                // Decorations section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Text(
                      '✨ Decorations',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final deco = PlantCatalog.allDecorations[index];
                        final isUnlocked =
                            provider.profile.isDecorationUnlocked(deco.id);
                        final canAfford =
                            provider.profile.sunlight >= deco.unlockCost;

                        return _buildShopItem(
                          context: context,
                          emoji: deco.emoji,
                          name: deco.name,
                          description: deco.description,
                          cost: deco.unlockCost,
                          isUnlocked: isUnlocked,
                          canAfford: canAfford,
                          onUnlock: () async {
                            final success = await provider.unlockDecoration(
                              deco.id,
                              deco.unlockCost,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success
                                      ? '${deco.name} unlocked! 🎉'
                                      : 'Not enough sunlight ☀️'),
                                ),
                              );
                            }
                          },
                        );
                      },
                      childCount: PlantCatalog.allDecorations.length,
                    ),
                  ),
                ),

                // IAP section (optional)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
          ),
                          child: Column(
                            children: [
                              const Text(
                                '💡 Tip',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Earn sunlight by completing habits daily!\nEach completion gives you 5 ☀️',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppTheme.textLight,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShopItem({
    required BuildContext context,
    required String emoji,
    required String name,
    required String description,
    required int cost,
    required bool isUnlocked,
    required bool canAfford,
    required VoidCallback onUnlock,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            style: TextStyle(
              fontSize: 48,
              color: isUnlocked ? null : Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textLight,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          if (isUnlocked)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.successGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Unlocked',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            ElevatedButton(
              onPressed: canAfford ? onUnlock : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: const Size(0, 0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('☀️', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    '$cost',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
