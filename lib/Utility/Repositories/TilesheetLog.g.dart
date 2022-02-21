// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TilesheetLog.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TilesheetLogAdapter extends TypeAdapter<TilesheetLog> {
  @override
  final int typeId = 1;

  @override
  TilesheetLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TilesheetLog(
      keyName: fields[0] as String,
      author: fields[1] as String,
      dateAdded: fields[2] as DateTime,
      customSpriteSheet: fields[3] as bool,
      internalPath: fields[4] as String,
      description: fields[5] as String,
      recommendedTilesList: (fields[6] as List).cast<int>(),
      tileCategoryMap: (fields[7] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as List).cast<int>())),
      srcSize: (fields[8] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, TilesheetLog obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.keyName)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.dateAdded)
      ..writeByte(3)
      ..write(obj.customSpriteSheet)
      ..writeByte(4)
      ..write(obj.internalPath)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.recommendedTilesList)
      ..writeByte(7)
      ..write(obj.tileCategoryMap)
      ..writeByte(8)
      ..write(obj.srcSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TilesheetLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
