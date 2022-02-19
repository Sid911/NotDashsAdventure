import 'dart:math';

import 'package:flame/components.dart';
import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/VectorInt.dart';

class DesignerGameState {
  DesignerGameState({this.size = 20})
      : defaultMatrix = List.generate(size, (index) => List.generate(size, (_) => -1)),
        baseMatrix = List.generate(size, (_) => List.generate(size, (_) => 0)) {
    highLightMatrix = List.from(defaultMatrix);
    highLightMatrix[0][0] = 115;
  }
  final _logger = Logger("DesignerGameState");

  int size;
  Vector2Int lastHighlightBlock = Vector2Int(x: 0, y: 0);
  HightLightRange? lastHighlightRange;
  List<List<int>> baseMatrix;
  late List<List<int>> highLightMatrix;
  List<List<int>> defaultMatrix;

  void toggleIndex(Vector2Int location, int replacingIndex) {
    if (location.x >= 0 && location.x <= baseMatrix[0].length && location.y >= 0 && location.y <= baseMatrix.length) {
      _logger.log(Level.INFO, "Index : $replacingIndex");
      baseMatrix[location.y][location.x] = replacingIndex;
      highLightMatrix[lastHighlightBlock.y][lastHighlightBlock.x] = -1;
      highLightMatrix[location.y][location.x] = 115;
      lastHighlightBlock = Vector2Int(x: location.x, y: location.y);
    }
  }

  void toggleIndexRange(Vector2Int startBlock, Vector2Int endBlock, int replacingIndex) {}

  void highlight(Vector2Int startBlock, Vector2Int endBlock) {
    highLightMatrix[lastHighlightBlock.y][lastHighlightBlock.x] = -1;
    startBlock.clampNegativeToZero();
    endBlock.clampNegativeToZero();
    // if blocks have no distance
    if (startBlock.distance(endBlock) < 1) return;
    // else compute the rectangle to highlight
    final h = HightLightRange(a: startBlock, b: endBlock);
    for (int i = h.lowerY; i <= h.higherY; i++) {
      highLightMatrix[i].setAll(h.lowerX, List<int>.filled(h.higherX - h.lowerX, 115));
    }
  }

  void resetHighlight() {
    highLightMatrix = List.generate(size, (index) => List.generate(size, (_) => -1));
  }

  void resetBaseMatrix() {
    baseMatrix = List.from(defaultMatrix);
  }

  bool isInsideMatrix(Vector2Int block) {
    if (block.x >= 0 && block.x <= baseMatrix[0].length && block.y >= 0 && block.y <= baseMatrix.length) return true;
    return false;
  }
}

class HightLightRange {
  HightLightRange({required Vector2Int a, required Vector2Int b})
      : lowerX = min(a.x, b.x),
        lowerY = min(a.y, b.y),
        higherX = max(a.x, b.x),
        higherY = max(a.y, b.y);

  int lowerX, lowerY;
  int higherX, higherY;
}
