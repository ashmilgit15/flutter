import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import '../models/plant_catalog.dart';
import '../utils/theme.dart';

/// Screen for adding or editing habits
class AddHabitScreen extends StatefulWidget {
  final Habit? habit;

  const AddHabitScreen({super.key, this.habit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _plantNameController;
  String _selectedPlantType = 'fern';
  TimeOfDay? _reminderTime;

  bool get isEditing => widget.habit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit?.name ?? '');
    _plantNameController = TextEditingController(
      text: widget.habit?.plantName ?? 'My Plant',
    );
    
    if (widget.habit != null) {
      _selectedPlantType = widget.habit!.plantType;
      if (widget.habit!.reminderTime != null) {
        final parts = widget.habit!.reminderTime!.split(':');
        _reminderTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _plantNameController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? TimeOfDay.now(),
    );
    
    if (time != null) {
      setState(() {
        _reminderTime = time;
      });
    }
  }

  String? _formatReminderTime() {
    if (_reminderTime == null) return null;
    return '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _saveHabit() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<HabitProvider>(context, listen: false);
      
      if (isEditing) {
        // Update existing habit
        final habit = widget.habit!;
        habit.name = _nameController.text;
        habit.plantName = _plantNameController.text;
        habit.plantType = _selectedPlantType;
        habit.reminderTime = _formatReminderTime();
        
        await provider.updateHabit(habit);
      } else {
        // Create new habit
        await provider.addHabit(
          name: _nameController.text,
          plantType: _selectedPlantType,
          plantName: _plantNameController.text,
          reminderTime: _formatReminderTime(),
        );
      }
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Habit' : 'New Habit'),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, provider, child) {
          final unlockedPlants = PlantCatalog.allPlants
              .where((plant) =>
                  plant.isStarter ||
                  provider.profile.isPlantUnlocked(plant.id))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Habit name
                  Text(
                    'Habit Name',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g., Drink 8 glasses of water',
                      prefixIcon: Icon(Icons.edit),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a habit name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Plant selection
                  Text(
                    'Choose Your Plant',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a plant to represent this habit',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textLight,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Plant grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: unlockedPlants.length,
                    itemBuilder: (context, index) {
                      final plant = unlockedPlants[index];
                      final isSelected = _selectedPlantType == plant.id;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPlantType = plant.id;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.paleGreen
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryGreen
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                plant.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                plant.name.split(' ').last,
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Plant name
                  Text(
                    'Plant Name',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _plantNameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g., Happy Fern',
                      prefixIcon: Icon(Icons.favorite),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please name your plant';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Reminder time
                  Text(
                    'Daily Reminder',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Get a gentle reminder at the same time each day',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textLight,
                        ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _pickTime,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.lightGreen),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.alarm, color: AppTheme.primaryGreen),
                          const SizedBox(width: 16),
                          Text(
                            _reminderTime != null
                                ? _reminderTime!.format(context)
                                : 'Set reminder time',
                            style: TextStyle(
                              color: _reminderTime != null
                                  ? AppTheme.textDark
                                  : AppTheme.textLight,
                            ),
                          ),
                          const Spacer(),
                          if (_reminderTime != null)
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () {
                                setState(() {
                                  _reminderTime = null;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveHabit,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(isEditing ? 'Save Changes' : 'Create Habit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
