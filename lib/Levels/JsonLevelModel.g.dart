// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JsonLevelModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LevelModelAdapter extends TypeAdapter<LevelModel> {
  @override
  final int typeId = 2;

  @override
  LevelModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LevelModel(
      LevelName: fields[0] as String,
      StoryLevel: fields[1] as bool,
      Layers: (fields[3] as List)
          .map((dynamic e) =>
              (e as List).map((dynamic e) => (e as List).cast<int>()).toList())
          .toList(),
      TilesetUID: fields[4] as String,
      Zoom: fields[5] as double,
      CameraPosition: (fields[6] as List).cast<double>(),
      PuzzleLayer: fields[7] as int,
      TilesetIncluded: fields[2] as bool,
      hexGradientStart: fields[8] as String,
      hexGradientEnd: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LevelModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.LevelName)
      ..writeByte(1)
      ..write(obj.StoryLevel)
      ..writeByte(2)
      ..write(obj.TilesetIncluded)
      ..writeByte(3)
      ..write(obj.Layers)
      ..writeByte(4)
      ..write(obj.TilesetUID)
      ..writeByte(5)
      ..write(obj.Zoom)
      ..writeByte(6)
      ..write(obj.CameraPosition)
      ..writeByte(7)
      ..write(obj.PuzzleLayer)
      ..writeByte(8)
      ..write(obj.hexGradientStart)
      ..writeByte(9)
      ..write(obj.hexGradientEnd);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelModel _$LevelModelFromJson(Map<String, dynamic> json) => LevelModel(
      LevelName: json['LevelName'] as String,
      StoryLevel: json['StoryLevel'] as bool,
      Layers: (json['Layers'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => (e as List<dynamic>).map((e) => e as int).toList())
              .toList())
          .toList(),
      TilesetUID: json['TilesetUID'] as String,
      Zoom: (json['Zoom'] as num).toDouble(),
      CameraPosition: (json['CameraPosition'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      PuzzleLayer: json['PuzzleLayer'] as int,
      TilesetIncluded: json['TilesetIncluded'] as bool,
      hexGradientStart: json['hexGradientStart'] as String? ?? "FFFFFF",
      hexGradientEnd: json['hexGradientEnd'] as String? ?? "9E9E9E",
    );

Map<String, dynamic> _$LevelModelToJson(LevelModel instance) =>
    <String, dynamic>{
      'LevelName': instance.LevelName,
      'StoryLevel': instance.StoryLevel,
      'TilesetIncluded': instance.TilesetIncluded,
      'Layers': instance.Layers,
      'TilesetUID': instance.TilesetUID,
      'Zoom': instance.Zoom,
      'CameraPosition': instance.CameraPosition,
      'PuzzleLayer': instance.PuzzleLayer,
      'hexGradientStart': instance.hexGradientStart,
      'hexGradientEnd': instance.hexGradientEnd,
    };
