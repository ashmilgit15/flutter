// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String,
      name: fields[1] as String,
      plantType: fields[2] as String,
      plantName: fields[3] as String,
      growthStage: fields[4] as int,
      currentStreak: fields[5] as int,
      longestStreak: fields[6] as int,
      createdAt: fields[7] as DateTime,
      lastCompletedAt: fields[8] as DateTime?,
      completionHistory: (fields[9] as List?)?.cast<DateTime>(),
      isWilted: fields[10] as bool,
      totalCompletions: fields[11] as int,
      reminderTime: fields[12] as String?,
      smartReminderTimes: (fields[13] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.plantType)
      ..writeByte(3)
      ..write(obj.plantName)
      ..writeByte(4)
      ..write(obj.growthStage)
      ..writeByte(5)
      ..write(obj.currentStreak)
      ..writeByte(6)
      ..write(obj.longestStreak)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastCompletedAt)
      ..writeByte(9)
      ..write(obj.completionHistory)
      ..writeByte(10)
      ..write(obj.isWilted)
      ..writeByte(11)
      ..write(obj.totalCompletions)
      ..writeByte(12)
      ..write(obj.reminderTime)
      ..writeByte(13)
      ..write(obj.smartReminderTimes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
