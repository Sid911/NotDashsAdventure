import 'dart:math';

import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/VectorInt.dart';

class DesignerGameState {
  DesignerGameState({this.size = 20})
      : defaultMatrix = List.generate(size, (index) => List.generate(size, (_) => -1)),
        baseMatrix = List.generate(1, (_) => List.generate(size, (_) => List.generate(size, (_) => -1))),
        gridMatrix = List.generate(size, (index) => List.generate(size, (_) => 119)) {
    highLightMatrix = List.from(defaultMatrix);
    highLightMatrix[0][0] = 115;
  }

  /// logger for the State
  final _logger = Logger("DesignerGameState");

  /// m and n for the square matrices [baseMatrix] and [highlightMatrix] and [gridMatrix]
  int size;
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
      highLightMatrix[location.y][location.x] = 117;
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
        lastHighlightRange!.lowerX - 1,
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
        highLightMatrix[i].setAll(h.lowerX - 1, List<int>.filled(h.higherX - h.lowerX + 1, 117));
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

  void save() {
    UnimplementedError("Implement Save method");
  }
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
