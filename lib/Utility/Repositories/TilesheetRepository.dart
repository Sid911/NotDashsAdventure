import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetLog.dart';
import 'package:path_provider/path_provider.dart';

class TilesheetRepository {
  // Constructors for the singleton
  factory TilesheetRepository() {
    return _instance;
  }
  TilesheetRepository._private() {
    logger = Logger("TilesheetRepo");
  }
  // fields
  static final TilesheetRepository _instance = TilesheetRepository._private();
  final Box<TilesheetLog> tileSheetBox = Hive.box<TilesheetLog>("tilesheet");
  static const String defaultTilesheet = "default";
  late Logger logger;

  get filename => null;

  Future<SpriteSheet?> getTileSheet({String tilesheetName = defaultTilesheet}) async {
    if (tilesheetName == defaultTilesheet) {
      logger.log(Level.INFO, "using default SpriteSheet");
      final TilesheetLog? log = tileSheetBox.get(defaultTilesheet);
      print(tileSheetBox.values);
      return SpriteSheet(
          image: await Flame.images.load(log!.internalPath),
          srcSize: Vector2(log.srcSize[0].toDouble(), log.srcSize[1].toDouble()));
    }
    if (tileSheetBox.containsKey(tilesheetName)) {
      final Directory directory = await getApplicationDocumentsDirectory();
    }
    return null;
  }
}
