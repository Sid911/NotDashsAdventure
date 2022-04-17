import 'dart:math';
import 'dart:convert';
import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:not_dashs_adventure/Utility/VectorInt.dart';
import 'package:not_dashs_adventure/Utility/direction.dart';
import 'package:not_dashs_adventure/Utility/puzzle.dart';

class LoaderGameState {
  LoaderGameState({
    required this.highlightSpriteIndex,
    required this.baseMatrix,
    required this.levelName,
    required this.puzzleLayer,
    int maxSolutionDistance = 100,
  })  : defaultMatrix = List.generate(baseMatrix[0].length,
            (index) => List.generate(baseMatrix[0].length, (_) => -1)),
        highLightMatrix = List.generate(baseMatrix[0].length,
            (index) => List.generate(baseMatrix[0].length, (_) => -1)),
        size = baseMatrix[0].length {
    highLightMatrix = List.from(defaultMatrix);
    // convert PuzzleRenderMatrix to tileMatrix
    List<List<PuzzleCell>> tempList =
        List<List<PuzzleCell>>.empty(growable: true);
    Point startBlock = Point(0, 0);
    Point endBlock = Point(0, 0);
    MotionDirection startDir = MotionDirection.N;
    // loop
    for (int i = 0; i < baseMatrix[puzzleLayer].length; i++) {
      List<PuzzleCell> cells = List<PuzzleCell>.empty(growable: true);
      for (int j = 0; j < baseMatrix[puzzleLayer][i].length; j++) {
        final element = baseMatrix[puzzleLayer][i][j];
        if (element == -2) {
          lastBlock = Vector2Int(x: j, y: i);
        }
        final cell = getPuzzleFromID(element);
        if (cell == PuzzleCell.sourceNW) {
          startBlock.x = j;
          startBlock.y = i;
          startDir = MotionDirection.NW;
        } else if (cell == PuzzleCell.sourceN) {
          startBlock.x = j;
          startBlock.y = i;
        } else if (cell == PuzzleCell.end) {
          endBlock.x = j;
          endBlock.y = i;
        }
        cells.add(getPuzzleFromID(element));
      }
      tempList.add(cells);
    }
    puzzle = Puzzle(
        data: tempList,
        maxSolDistance: maxSolutionDistance,
        start: startBlock,
        end: endBlock,
        startDirection: startDir);

    highlight(lastBlock);
  }

  /// logger for the State
  final _logger = Logger("GameState");
  String levelName;

  /// m and n for the square matrices [baseMatrix] and [highlightMatrix] and [gridMatrix]
  int size;
  int puzzleLayer;
  final int highlightSpriteIndex;

  /// last Highlighted Block with single Click
  Vector2Int lastBlock = Vector2Int(x: 1, y: 1);

  List<List<List<int>>> baseMatrix;
  late List<List<int>> highLightMatrix;
  List<List<int>> defaultMatrix;
  late Puzzle puzzle;

  void toggleIndex(Vector2Int location) {
    print("new location : ${location.x} , ${location.y}");
    print("new location : ${lastBlock.x} , ${lastBlock.y}");

    if (isInsideMatrix(location) &&
        puzzle.cellCanBeMoved(Point(location.x, location.y)) &&
        lastBlock.distance(location) == 1) {
      baseMatrix[puzzleLayer][lastBlock.y][lastBlock.x] =
          baseMatrix[puzzleLayer][location.y][location.x];
      baseMatrix[puzzleLayer][location.y][location.x] = -2;
      if (puzzle.swapCells(lastBlock.toPoint(), location.toPoint())) {
        resetHighlight();
        lastBlock = location;
        highlight(location);
      } else {
        _logger.log(Level.SHOUT, "Desync Between State and puzzle");
      }
    }
  }

  void highlight(Vector2Int userBlock) {
    final mX = userBlock.offset(-1, 0);
    final pX = userBlock.offset(1, 0);
    final mY = userBlock.offset(0, -1);
    final pY = userBlock.offset(0, 1);

    if (isInsideMatrix(mX) && puzzle.cellCanBeMoved(mX.toPoint()))
      highLightMatrix[userBlock.y][userBlock.x - 1] = highlightSpriteIndex;
    if (isInsideMatrix(pX) && puzzle.cellCanBeMoved(pX.toPoint()))
      highLightMatrix[userBlock.y][userBlock.x + 1] = highlightSpriteIndex;
    if (isInsideMatrix(mY) && puzzle.cellCanBeMoved(mY.toPoint()))
      highLightMatrix[userBlock.y - 1][userBlock.x] = highlightSpriteIndex;
    if (isInsideMatrix(pY) && puzzle.cellCanBeMoved(pY.toPoint()))
      highLightMatrix[userBlock.y + 1][userBlock.x] = highlightSpriteIndex;
  }

  void resetHighlight() {
    if (isInsideMatrix(lastBlock.offset(-1, 0)))
      highLightMatrix[lastBlock.y][lastBlock.x - 1] = -1;
    if (isInsideMatrix(lastBlock.offset(1, 0)))
      highLightMatrix[lastBlock.y][lastBlock.x + 1] = -1;
    if (isInsideMatrix(lastBlock.offset(0, -1)))
      highLightMatrix[lastBlock.y - 1][lastBlock.x] = -1;
    if (isInsideMatrix(lastBlock.offset(0, 1)))
      highLightMatrix[lastBlock.y + 1][lastBlock.x] = -1;
  }

  void resetBaseMatrix() {
    baseMatrix = List.from(defaultMatrix);
  }

  List<Point> computePuzzle() {
    return puzzle.getCurrentLightPath();
  }

  bool isInsideMatrix(Vector2Int block) {
    if (block.x >= 0 && block.x <= size && block.y >= 0 && block.y <= size)
      return true;
    return false;
  }
}
