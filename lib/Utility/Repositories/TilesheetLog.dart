import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TilesheetLog.g.dart';

@JsonSerializable()
@HiveType(typeId: 1, adapterName: 'TilesheetLogAdapter')
class TilesheetLog {
  TilesheetLog({
    required this.keyName,
    required this.author,
    required this.dateAdded,
    required this.customSpriteSheet,
    required this.internalPath,
    required this.description,
    required this.recommendedTilesList,
    required this.tileCategoryMap,
    required this.srcSize,
    required this.gridIndex,
    required this.highlightIndex,
    required this.puzzlePieceSize,
  })  : assert(srcSize.length == 2),
        assert(puzzlePieceSize.length == 2);
  @HiveField(0)
  final String keyName;
  @HiveField(1)
  final String author;
  @HiveField(2)
  final DateTime dateAdded;
  @HiveField(3)
  final bool customSpriteSheet;
  @HiveField(4)
  String internalPath;
  @HiveField(5)
  String description;
  @HiveField(6)
  List<int> recommendedTilesList;
  @HiveField(7)
  Map<String, List<int>> tileCategoryMap;
  @HiveField(8)
  List<int> srcSize;
  @HiveField(9)
  int gridIndex;
  @HiveField(10)
  int highlightIndex;
  @HiveField(11)
  List<int> puzzlePieceSize;

  factory TilesheetLog.fromJson(Map<String, dynamic> jsonMap) => _$TilesheetLogFromJson(jsonMap);
  Map<String, dynamic> toJson() => _$TilesheetLogToJson(this);
}
