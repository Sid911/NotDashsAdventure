import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:not_dashs_adventure/Utility/puzzle.dart';

class TempLevel extends FlameGame
    with MouseMovementDetector, TapDetector, VerticalDragDetector, HorizontalDragDetector {
  late List<List<PuzzleCell>> initialMatrix;
  late Puzzle puzzle;
  @override
  bool debugMode = true;

  final topLeft = Vector2.all(100);

  static const srcTileSize = 64.0;
  static const destTileSize = srcTileSize;

  static const tileHeight = 32.0;

  final originColor = Paint()..color = const Color(0xFFFF00FF);
  final originColor2 = Paint()..color = const Color(0xFFAA55FF);

  late IsometricTileMapComponent base;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final tilesetImage = await images.load('iso.png');
    final tileset = SpriteSheet(
      image: tilesetImage,
      srcSize: Vector2.all(srcTileSize),
    );

    initialMatrix = [
      [PuzzleCell.blocked, PuzzleCell.open, PuzzleCell.blocked, PuzzleCell.blocked, PuzzleCell.blocked],
      [PuzzleCell.blocked, PuzzleCell.rSW, PuzzleCell.open, PuzzleCell.open, PuzzleCell.rNE],
      [PuzzleCell.blocked, PuzzleCell.blocked, PuzzleCell.blocked, PuzzleCell.blocked, PuzzleCell.open],
      [PuzzleCell.blocked, PuzzleCell.rNW, PuzzleCell.open, PuzzleCell.open, PuzzleCell.rSE],
      [PuzzleCell.blocked, PuzzleCell.open, PuzzleCell.blocked, PuzzleCell.blocked, PuzzleCell.blocked],
    ];

    puzzle = Puzzle(data: initialMatrix, maxSolDistance: 9, start: Point(1, 4), end: Point(1, 0));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
