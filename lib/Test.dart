import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:not_dashs_adventure/Utility/direction.dart';

import 'Utility/puzzle.dart';

class IsometricTileMapExample extends FlameGame with MouseMovementDetector, TapDetector {
  static const String description = '''
    Shows an example of how to use the `IsometricTileMapComponent`.\n\n
    Move the mouse over the board to see a selector appearing on the tiles.
  ''';

  final topLeft = Vector2(700, 100);

  static const srcTileSize = 111.0;
  static const destTileSize = srcTileSize;

  static const halfSize = false;
  static const tileHeight = 128.0;

  final originColor = Paint()..color = const Color(0xFFFF00FF);
  final originColor2 = Paint()..color = const Color(0xFFAA55FF);

  late IsometricTileMapComponent base;

  IsometricTileMapExample();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    overlays.add("designer");
    final tilesetImage = await images.load('tilesheet.png');
    final tileset = SpriteSheet(
      image: tilesetImage,
      srcSize: Vector2(srcTileSize, 128),
    );
    final matrix = List.filled(10, List.filled(2, 40));

    add(base = IsometricTileMapComponent(
      tileset,
      matrix,
      destTileSize: Vector2.all(destTileSize),
      tileHeight: tileHeight,
      position: topLeft,
      anchor: Anchor.topLeft,
    ));
    testPuzzle();
  }

  @override
  void render(Canvas canvas) {
    // base.render(canvas);
    canvas.renderPoint(topLeft, size: 5, paint: originColor);
    canvas.renderPoint(
      topLeft.clone()..y -= tileHeight,
      size: 5,
      paint: originColor2,
    );
    super.render(canvas);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    final screenPosition = info.eventPosition.game;
    final block = base.getBlock(screenPosition);
  }

  @override
  void onTapDown(TapDownInfo info) {
    final screenPosition = info.eventPosition.game;
    final block = base.getBlock(screenPosition);
    print('x : ${block.x} , y : ${block.y}');
  }

  void testPuzzle() {
    List<List<PuzzleCell>> initialMatrix = [
      [PuzzleCell.blocked, PuzzleCell.open, PuzzleCell.blocked, PuzzleCell.blocked, PuzzleCell.blocked],
      [PuzzleCell.blocked, PuzzleCell.rBottomLeft, PuzzleCell.open, PuzzleCell.blocked, PuzzleCell.rTopRight],
      [PuzzleCell.blocked, PuzzleCell.blocked, PuzzleCell.blocked, PuzzleCell.open, PuzzleCell.blocked],
      [PuzzleCell.open, PuzzleCell.open, PuzzleCell.open, PuzzleCell.rBottomRight, PuzzleCell.blocked],
      [PuzzleCell.blocked, PuzzleCell.open, PuzzleCell.blocked, PuzzleCell.blocked, PuzzleCell.blocked],
    ];

    Puzzle puzzle = Puzzle(data: initialMatrix, maxSolDistance: 9, start: Point(0, 3), end: Point(1, 0), startDirection: MotionDirection.right);
    puzzle.swapCells(Point(4, 1), Point(3, 1));
    final result = puzzle.getCurrentLightPath();
    for (Point x in result) {
      print("x : ${x.x} , y : ${x.y}");
    }
  }
}
