import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'JsonLevelModel.g.dart';

@JsonSerializable()
@HiveType(typeId: 2, adapterName: "LevelModelAdapter")
class LevelModel {
  LevelModel({
    required this.LevelName,
    required this.StoryLevel,
    required this.Layers,
    required this.TilesetUID,
    required this.Zoom,
    required this.CameraPosition,
    required this.PuzzleLayer,
    required this.TilesetIncluded,
    this.hexGradientStart = "FFFFFF",
    this.hexGradientEnd = "9E9E9E",
  });
  @HiveField(0)
  String LevelName;
  @HiveField(1)
  bool StoryLevel;
  @HiveField(2)
  bool TilesetIncluded;
  @HiveField(3)
  List<List<List<int>>> Layers;
  @HiveField(4)
  String TilesetUID;
  //Camera
  @HiveField(5)
  double Zoom;
  @HiveField(6)
  List<double> CameraPosition;
  // Puzzle Layer
  @HiveField(7)
  int PuzzleLayer;
  // Color
  @HiveField(8)
  String hexGradientStart;
  @HiveField(9)
  String hexGradientEnd;

  factory LevelModel.fromJson(Map<String, dynamic> jsonMap) => _$LevelModelFromJson(jsonMap);
  Map<String, dynamic> toJson() => _$LevelModelToJson(this);
}
