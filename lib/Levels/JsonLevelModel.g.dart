// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JsonLevelModel.dart';

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
    );

Map<String, dynamic> _$LevelModelToJson(LevelModel instance) =>
    <String, dynamic>{
      'LevelName': instance.LevelName,
      'StoryLevel': instance.StoryLevel,
      'Layers': instance.Layers,
      'TilesetUID': instance.TilesetUID,
    };
