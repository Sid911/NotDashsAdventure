import 'package:hive/hive.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetLog.dart';

void initForFirstTime() {
  final box = Hive.box<TilesheetLog>("tilesheet");
  final defaultTilesheet = TilesheetLog(
    keyName: "default",
    author: "Siddharth Sinha",
    dateAdded: DateTime.now(),
    customSpriteSheet: false,
    internalPath: "tilesheet",
    description: "The default tilelsheet used to initialize for the user",
  );
  box.put("default", defaultTilesheet);
}
