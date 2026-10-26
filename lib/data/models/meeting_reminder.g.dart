// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingReminderAdapter extends TypeAdapter<MeetingReminder> {
  @override
  final int typeId = 2;

  @override
  MeetingReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MeetingReminder(
      id: fields[0] as String,
      title: fields[1] as String,
      dateTime: fields[2] as DateTime,
      agenda: fields[3] as String,
      contactCardId: fields[4] as String?,
      notificationId: fields[5] as int,
      isCompleted: fields[6] as bool,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MeetingReminder obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.agenda)
      ..writeByte(4)
      ..write(obj.contactCardId)
      ..writeByte(5)
      ..write(obj.notificationId)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
