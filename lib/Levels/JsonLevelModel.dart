import 'package:json_annotation/json_annotation.dart';

part 'JsonLevelModel.g.dart';

@JsonSerializable()
class LevelModel {
  String LevelName;
  bool StoryLevel;
  List<List<List<int>>> Layers;
  String TilesetUID;

  LevelModel({required this.LevelName, required this.StoryLevel, required this.Layers, required this.TilesetUID});
  factory LevelModel.fromJson(Map<String, dynamic> jsonMap) => _$LevelModelFromJson(jsonMap);
  Map<String, dynamic> toJson() => _$LevelModelToJson(this);
}
