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

  String currentTilesheetKey = defaultTilesheet;

  final Box<TilesheetLog> tileSheetBox = Hive.box<TilesheetLog>("tilesheet");
  static const String defaultTilesheet = "tutorial";

  late Logger logger;
  TilesheetLog? currentTilesheetLog;
  SpriteSheet? currentSpritesheet;
  get filename => null;

  Future<SpriteSheet?> getTileSheet({String tilesheetName = defaultTilesheet}) async {
    if (currentTilesheetLog != null && currentSpritesheet != null && currentTilesheetLog?.keyName == defaultTilesheet) {
      return currentSpritesheet;
    }
    if (tilesheetName == defaultTilesheet) {
      logger.log(Level.INFO, "using default SpriteSheet");
      final TilesheetLog? log = tileSheetBox.get(defaultTilesheet);

      currentTilesheetLog = log;
      currentSpritesheet = SpriteSheet(
          image: await Flame.images.load(log!.internalPath),
          srcSize: Vector2(log.srcSize[0].toDouble(), log.srcSize[1].toDouble()));
      return currentSpritesheet;
    } else if (tileSheetBox.containsKey(tilesheetName)) {
      currentTilesheetKey = tilesheetName;
      final Directory directory = await getApplicationDocumentsDirectory();
    }
    return null;
  }

  Future<List<Sprite>> getPuzzleSprites() async {
    final String keyName = currentTilesheetLog == null ? defaultTilesheet : currentTilesheetLog!.keyName;

    final image = (await getTileSheet(tilesheetName: keyName))!.image;
    final size = currentTilesheetLog!.puzzlePieceSize;
    final List<Sprite> sprites = List.empty(growable: true);
    try {
      for (int i = 0; i < 8; i++) {
        final position = Vector2((image.width + i * size[0]).toDouble(), (image.height - size[1]).toDouble());
        sprites.add(Sprite(image, srcSize: Vector2(size[0].toDouble(), size[1].toDouble()), srcPosition: position));
      }
      return sprites;
    } catch (e) {
      logger.log(Level.SEVERE, "Error TilesheetRepository : ", e);
      return [];
    }
    return [];
  }
}
