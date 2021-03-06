import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Levels/JsonLevelModel.dart';
import 'package:not_dashs_adventure/Pages/UserLevels/userLevelCard.dart';

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

  void importLevel(LevelModel levelModel) {
    userBox.put(levelModel.LevelName, levelModel);
  }

  List<Widget> getUserLevelCards() {
    if (userBox.isEmpty) {
      return [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "No levels yet ... Go the level Designer and make some",
            style: TextStyle(fontFamily: "Pixel"),
          ),
        ),
      ];
    }
    List<Widget> list = List<Widget>.empty(growable: true);
    for (LevelModel i in getAllUserLevels) {
      list.add(UserLevelCard(model: i, repository: _instance));
    }
    return list;
  }
}
