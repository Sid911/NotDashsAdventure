import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Levels/JsonLevelModel.dart';

class LevelsRepository {
  // Constructors for the singleton
  factory LevelsRepository() {
    return _instance;
  }

  LevelsRepository._private() {
    logger = Logger("TilesheetRepo");
  }

  // fields
  static final LevelsRepository _instance = LevelsRepository._private();
  late Logger logger;

  final Box<LevelModel> userBox = Hive.box<LevelModel>('userLevels');

  Iterable<LevelModel> get getAllUserLevels => userBox.values;
}
