// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactCardAdapter extends TypeAdapter<ContactCard> {
  @override
  final int typeId = 1;

  @override
  ContactCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactCard(
      id: fields[0] as String,
      name: fields[1] as String,
      company: fields[2] as String,
      jobTitle: fields[3] as String,
      phones: (fields[4] as List).cast<String>(),
      email: fields[5] as String,
      address: fields[6] as String,
      gstin: fields[7] as String,
      categoryId: fields[8] as String,
      voiceMemoPath: fields[9] as String?,
      notes: fields[10] as String,
      tags: (fields[11] as List).cast<String>(),
      photoFrontPath: fields[12] as String?,
      photoBackPath: fields[13] as String?,
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime?,
      website: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContactCard obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.company)
      ..writeByte(3)
      ..write(obj.jobTitle)
      ..writeByte(4)
      ..write(obj.phones)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.gstin)
      ..writeByte(8)
      ..write(obj.categoryId)
      ..writeByte(9)
      ..write(obj.voiceMemoPath)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.photoFrontPath)
      ..writeByte(13)
      ..write(obj.photoBackPath)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.website);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
