import 'dart:math';
import 'dart:convert';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Levels/JsonLevelModel.dart';
import 'package:not_dashs_adventure/Utility/VectorInt.dart';
import 'package:path_provider/path_provider.dart';

class DesignerGameState {
  DesignerGameState({
    required this.gridSpriteIndex,
    required this.highlightSpriteIndex,
    this.levelName = "Untitled",
    this.size = 10,
  })  : defaultMatrix = List.generate(size, (index) => List.generate(size, (_) => -1)),
        baseMatrix = List.generate(1, (_) => List.generate(size, (_) => List.generate(size, (_) => -1))),
        gridMatrix = List.generate(size, (index) => List.generate(size, (_) => gridSpriteIndex)) {
    highLightMatrix = List.from(defaultMatrix);
    highLightMatrix[0][0] = highlightSpriteIndex;
  }

  /// logger for the State
  final _logger = Logger("DesignerGameState");
  String levelName;

  /// m and n for the square matrices [baseMatrix] and [highlightMatrix] and [gridMatrix]
  int size;
  final int gridSpriteIndex;
  final int highlightSpriteIndex;
  bool isSavedBefore = false;
  bool isLoaded = false;

  /// last Highlighted Block with single Click
  Vector2Int lastHighlightBlock = Vector2Int(x: 0, y: 0);
  HighlightRange? lastHighlightRange;
  List<List<List<int>>> baseMatrix;
  List<List<int>> gridMatrix;
  late List<List<int>> highLightMatrix;
  List<List<int>> defaultMatrix;

  void toggleIndex(Vector2Int location, int replacingIndex, int layerIndex) {
    checkForLayer(layerIndex);
    if (location.x >= 0 &&
        location.x <= baseMatrix[layerIndex][0].length &&
        location.y >= 0 &&
        location.y <= baseMatrix[layerIndex].length) {
      _logger.log(Level.INFO, "Index : $replacingIndex");
      baseMatrix[layerIndex][location.y][location.x] = replacingIndex;
      highLightMatrix[lastHighlightBlock.y][lastHighlightBlock.x] = -1;
      highLightMatrix[location.y][location.x] = highlightSpriteIndex;
      lastHighlightBlock = Vector2Int(x: location.x, y: location.y);
    } else {
      _logger.log(Level.SHOUT, '''LevelDesignerGameState:
      location.x >= 0 : ${location.x >= 0}
      location.x <= baseMatrix[layerIndex][0].length : ${location.x <= baseMatrix[layerIndex][0].length} 
      location.y >= 0 :  ${location.y >= 0}
      location.y <= baseMatrix[layerIndex].length ${location.y <= baseMatrix[layerIndex].length}''');
    }
  }

  void toggleIndexRangeForLastHighlight({required int replaceIndex, required int layerIndex}) {
    if (lastHighlightRange == null) return;
    checkForLayer(layerIndex);
    for (int i = lastHighlightRange!.lowerY; i <= lastHighlightRange!.higherY; i++) {
      baseMatrix[layerIndex][i].setAll(
        lastHighlightRange!.lowerX,
        List<int>.filled(lastHighlightRange!.higherX - lastHighlightRange!.lowerX + 1, replaceIndex),
      );
    }
  }

  void highlight(Vector2Int startBlock, Vector2Int endBlock) {
    highLightMatrix[lastHighlightBlock.y][lastHighlightBlock.x] = -1;

    startBlock.clampNegativeToZero();
    endBlock.clampNegativeToZero();
    // if blocks have no distance
    if (startBlock.distance(endBlock) < 1) return;
    // else compute the rectangle to highlight
    final h = HighlightRange(initial: startBlock, b: endBlock);
    int minY = lastHighlightRange != null ? min(h.lowerY, lastHighlightRange!.lowerY) : h.lowerY;
    int maxY = lastHighlightRange != null ? max(h.higherY, lastHighlightRange!.higherY) : h.higherY;
    for (int i = minY; i <= maxY; i++) {
      highLightMatrix[i] = List<int>.generate(size, (index) => -1);
      if (i >= h.lowerY && i <= h.higherY) {
        highLightMatrix[i].setAll(h.lowerX, List<int>.filled(h.higherX - h.lowerX + 1, highlightSpriteIndex));
      }
    }
    lastHighlightRange = h;
  }

  void resetHighlight() {
    lastHighlightRange = null;
    highLightMatrix = List.generate(size, (index) => List.generate(size, (_) => -1));
  }

  void resetBaseMatrix() {
    baseMatrix = List.from(defaultMatrix);
  }

  bool checkForLayer(int index) {
    if (baseMatrix.length <= index) {
      _logger.log(Level.INFO, "Layer Index out of range : $index");
      int difference = index - baseMatrix.length + 1;
      while (difference > 0) {
        _logger.log(Level.INFO, "Adding layer to base matrix");
        baseMatrix.add(List.generate(size, (index) => List.generate(size, (_) => -1)));
        difference--;
      }
      return true;
    }
    return false;
  }

  bool isInsideMatrix(Vector2Int block, {int? layerIndex}) {
    final int rowLen = layerIndex != null ? baseMatrix[layerIndex][0].length : baseMatrix[0].length;
    final int colLen = layerIndex != null ? baseMatrix[layerIndex].length : baseMatrix.length;
    if (block.x >= 0 && block.x <= rowLen && block.y >= 0 && block.y <= colLen) return true;
    return false;
  }

  // Save Specific Code
  void save({
    required String tilesetUID,
    required double cameraZoom,
    required Vector2 cameraPosition,
    required bool tilesetIncluded,
    required int puzzleLayer,
    required Color gradientBegin,
    required Color gradientEnd,
    bool export = false,
  }) {
    List<List<List<int>>> matrixToBeSaved = List.empty(growable: true);
    // remove empty layers
    for (int i = 0; i < baseMatrix.length; i++) {
      if (_layerContainsStuff(baseMatrix[i])) {
        matrixToBeSaved.add(List.from(baseMatrix[i]));
      }
    }
    final LevelModel levelModel = LevelModel(
      LevelName: levelName,
      StoryLevel: false,
      Layers: matrixToBeSaved,
      TilesetUID: tilesetUID,
      Zoom: cameraZoom,
      CameraPosition: [cameraPosition.x, cameraPosition.y],
      PuzzleLayer: puzzleLayer,
      TilesetIncluded: tilesetIncluded,
      hexGradientStart: gradientBegin.value.toRadixString(16),
      hexGradientEnd: gradientEnd.value.toRadixString(16),
    );
    final Box<LevelModel> box = Hive.box("userLevels");
    box.put(levelName, levelModel);

    if (export) {
      final jsonMap = levelModel.toJson();
      final String jsonString = jsonEncode(jsonMap);
      print(jsonString);
    }
  }
}

// if layer is empty or not
bool _layerContainsStuff(List<List<int>> layer) {
  for (int i = 0; i < layer.length; i++) {
    for (int j = 0; j < layer[i].length; j++) {
      if (layer[i][j] != -1) return true;
    }
  }
  return false;
}

class HighlightRange {
  HighlightRange({required this.initial, required Vector2Int b})
      : lowerX = min(initial.x, b.x),
        lowerY = min(initial.y, b.y),
        higherX = max(initial.x, b.x),
        higherY = max(initial.y, b.y) {
    // Store all the points just in case
    topLeft = Vector2Int(x: lowerX, y: lowerY);
    topRight = Vector2Int(x: higherX, y: lowerY);
    bottomLeft = Vector2Int(x: lowerX, y: higherY);
    bottomRight = Vector2Int(x: higherX, y: higherY);
  }

  int lowerX, lowerY;
  int higherX, higherY;
  late Vector2Int topLeft, topRight, bottomLeft, bottomRight, initial;
}
