// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obj_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveObjAdapter extends TypeAdapter<HiveObj> {
  @override
  final int typeId = 0;

  @override
  HiveObj read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveObj(
      id: fields[0] as int,
      message: fields[1] as String,
      isEnabled: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveObj obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveObjAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
