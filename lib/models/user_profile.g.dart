// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 1;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      sunlight: fields[0] as int,
      unlockedPlants: (fields[1] as List?)?.cast<String>(),
      unlockedDecorations: (fields[2] as List?)?.cast<String>(),
      hasCompletedOnboarding: fields[3] as bool,
      createdAt: fields[4] as DateTime?,
      selectedTheme: fields[5] as String,
      soundEnabled: fields[6] as bool,
      notificationsEnabled: fields[7] as bool,
      totalHabitsCompleted: fields[8] as int,
      consecutiveDaysActive: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.sunlight)
      ..writeByte(1)
      ..write(obj.unlockedPlants)
      ..writeByte(2)
      ..write(obj.unlockedDecorations)
      ..writeByte(3)
      ..write(obj.hasCompletedOnboarding)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.selectedTheme)
      ..writeByte(6)
      ..write(obj.soundEnabled)
      ..writeByte(7)
      ..write(obj.notificationsEnabled)
      ..writeByte(8)
      ..write(obj.totalHabitsCompleted)
      ..writeByte(9)
      ..write(obj.consecutiveDaysActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
