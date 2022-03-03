import 'package:hive/hive.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetLog.dart';

void initForFirstTime(Box<TilesheetLog> box) {
  final recommendedDefault = List<int>.generate(15, (index) => index);
  recommendedDefault.add(121);
  final defaultTilesheet = TilesheetLog(
      keyName: "default",
      author: "Siddharth Sinha",
      dateAdded: DateTime.now(),
      customSpriteSheet: false,
      internalPath: "tilesheet.png",
      description: "The default tilesheet used to initialize for the user",
      recommendedTilesList: recommendedDefault,
      srcSize: <int>[111, 128],
      gridIndex: 119,
      heightlightIndex: 119,
      tileCategoryMap: Map<String, List<int>>.from(
        {
          "Green/Foliage Tiles": <int>[0, 11, 12, 15, 17, 26, 27, 28, 29, 31, 38, 66, 67, 68, 69, 121],
          "Ground/Sand Tiles": <int>[
            1,
            2,
            3,
            4,
            6,
            7,
            8,
            9,
            10,
            13,
            16,
            20,
            21,
            22,
            23,
            24,
            25,
            26,
            27,
            76,
            77,
            78,
            79,
            80,
            138,
            139
          ],
          "Water/Ice Tiles": <int>[4, 5, 13, 14, 18, 19, 34, 41, 43, 44, 51, 83],
          "Gravel/Rock/Brick Tiles": List<int>.empty(),
          "Selection Tiles (used for grid etc.)": List<int>.generate(11, (index) => 90 + index),
        },
      ));
  final tutorialTilesheet = TilesheetLog(
      keyName: "tutorial",
      author: "Siddharth Sinha",
      dateAdded: DateTime.now(),
      customSpriteSheet: false,
      internalPath: "tutorialTilesheet.png",
      description:
          "This tilesheet is gearbox version with shadows etc. which is used to display tutorial levels in the game",
      srcSize: [225, 257],
      gridIndex: 11,
      heightlightIndex: 10,
      recommendedTilesList: List.generate(10, (index) => index),
      tileCategoryMap: {});
  box.put("default", defaultTilesheet);
  box.put("tutorial", tutorialTilesheet);
}
