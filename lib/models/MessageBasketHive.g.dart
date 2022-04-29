// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MessageBasketHive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageBasketHiveAdapter extends TypeAdapter<MessageBasketHive> {
  @override
  final int typeId = 0;

  @override
  MessageBasketHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageBasketHive()
      ..sentByUser = fields[0] as bool?
      ..message = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, MessageBasketHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.sentByUser)
      ..writeByte(1)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageBasketHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
