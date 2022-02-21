import 'package:hive/hive.dart';

part 'TilesheetLog.g.dart';

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
  }) : assert(srcSize.length != 2);
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
}
