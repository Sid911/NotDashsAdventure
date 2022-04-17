import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:not_dashs_adventure/Levels/JsonLevelModel.dart';
import 'package:not_dashs_adventure/Pages/LevelLoader/LevelLoaderGameState.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';
import 'package:not_dashs_adventure/Utility/VectorInt.dart';

import '../../Utility/puzzle.dart';
import '../Components/IsometricTileMapCustom.dart';

class LevelLoader extends FlameBlocGame
    with TapDetector, ScrollDetector, ScaleDetector, FPSCounter {
  LevelLoader({required this.iModel});
  // Level Mode
  LevelModel iModel;
  // Paints
  static final fpsTextPaint = TextPaint(
    style: const TextStyle(color: Color(0xFFFF0000)),
  );
  static final linePaint = Paint()..color = const Color(0xFF000000);
  final backgroundPaint = Paint();
  late Rect rect;
  final topLeft = Vector2(0, 0);

  static double srcTileSize = 225.0;

  static const halfSize = false;
  static double tileHeight = 257.0;

  late LoaderGameState _gameState;
  final TilesheetRepository _tilesheetRepository = TilesheetRepository();
  DateTime? _clickStart;

  bool _clickHeld = false;
  bool reRenderBackground = true;

  List<IsometricTileMapCustom> envLayers =
      List<IsometricTileMapCustom>.empty(growable: true);
  late List<Point> currentLightPath;
  late IsometricTileMapCustom _highLightLayer;

  late Vector2 startPosition;
  late SpriteSheet tileset;

  @override
  Future<void> onLoad() async {
    camera.setRelativeOffset(Anchor.center);
    camera.speed = 100;
    camera.zoom = iModel.Zoom;
    await super.onLoad();
    // Load the basic Tileset and set the state

    final loadedTileset = await _tilesheetRepository.getTileSheet(
        tilesheetName: iModel.TilesetUID);

    assert(loadedTileset != null);
    _gameState = LoaderGameState(
      highlightSpriteIndex:
          _tilesheetRepository.currentTilesheetLog!.highlightIndex,
      levelName: iModel.LevelName,
      puzzleLayer: iModel.PuzzleLayer,
      baseMatrix: iModel.Layers,
    );
    tileset = loadedTileset!;
    // get the src dimension
    srcTileSize =
        _tilesheetRepository.currentTilesheetLog!.srcSize[0].toDouble();
    tileHeight =
        _tilesheetRepository.currentTilesheetLog!.srcSize[1].toDouble();

    // Add TileMaps
    computeEnvironment(0);
    _highLightLayer = IsometricTileMapCustom(
      tileset,
      _gameState.highLightMatrix,
      position: Vector2(0, -iModel.PuzzleLayer * tileHeight / 2),
      anchor: Anchor.topLeft,
      priority: 100,
    );
  }

  @override
  void onAttach() {
    super.onAttach();
    // get height and width and assign paint
    assignBackground(
      startingColor: Color(int.parse(iModel.hexGradientStart, radix: 16)),
      endingColor: Color(int.parse(iModel.hexGradientEnd, radix: 16)),
    );
  }

  void computeLinePath() {
    currentLightPath = _gameState.computePuzzle();
    envLayers[_gameState.puzzleLayer].points = currentLightPath;
    envLayers[_gameState.puzzleLayer].renderLines = true;
    if (currentLightPath.last == _gameState.puzzle.end) {
      overlays.add("levelComplete");
    }
    ;
  }

  void computeEnvironment(int initial) {
    for (int i = initial; i < _gameState.baseMatrix.length; i++) {
      final newPosition = Vector2(0, -1 * i * tileHeight / 2);
      envLayers.add(IsometricTileMapCustom(
        tileset,
        _gameState.baseMatrix[i],
        priority: i,
        position: newPosition,
        anchor: Anchor.topLeft,
        propSize: Vector2(
            _tilesheetRepository.currentTilesheetLog!.puzzlePieceSize[0]
                .toDouble(),
            _tilesheetRepository.currentTilesheetLog!.puzzlePieceSize[1]
                .toDouble()),
      ));
    }
  }

  void assignBackground({
    Color startingColor = Colors.white,
    Color endingColor = Colors.grey,
    Alignment beginAlignment = Alignment.topCenter,
    Alignment endAlignment = Alignment.bottomCenter,
  }) {
    rect = Rect.fromLTWH(0, 0, size.x, size.y);
    backgroundPaint.shader = LinearGradient(
      colors: [
        startingColor,
        endingColor,
      ],
      begin: beginAlignment,
      end: endAlignment,
    ).createShader(rect);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect, backgroundPaint);
    for (int i = 0; i < envLayers.length; i++) {
      add(envLayers[i]);
    }
    add(_highLightLayer);
    if (debugMode) {
      final double currentfps = fps(100);
      if (currentfps < 20) {
        fpsTextPaint.render(
            canvas, currentfps.roundToDouble().toString(), Vector2(0, 200));
      }
      // print(fps(100).toString());
    }
    super.render(canvas);
  }

  @override
  void onTapUp(TapUpInfo info) {
    _clickStart = null;
    final block =
        envLayers[iModel.PuzzleLayer].getBlock(info.eventPosition.game);
    _gameState.toggleIndex(Vector2Int.fromBlock(block: block));
  }

  @override
  void onTapDown(TapDownInfo info) {
    _clickStart = DateTime.now();
  }

  void clampZoom() {
    camera.zoom = camera.zoom.clamp(0.05, 3.0);
  }

  static const zoomPerScrollUnit = 0.02;

  @override
  void onScroll(PointerScrollInfo info) {
    camera.zoom += info.scrollDelta.game.y.sign * zoomPerScrollUnit;
    clampZoom();
  }

  late double startZoom;
  @override
  void onScaleStart(ScaleStartInfo info) {
    // get the position and zoom the scale started from
    startPosition = info.eventPosition.game;
    startZoom = camera.zoom;

    // if difference between the top down and scale start is more than 600ms ... that means user is trying to select
    final currentTime = DateTime.now();
    if (_clickStart != null &&
        currentTime.difference(_clickStart!).inMilliseconds > 300) {
      _clickHeld = true;
    }
  }

  // @override
  // void onLongPressMoveUpdate(LongPressMoveUpdateInfo info) {}
  // Todo : Replace the old logic for long Press detection with new one

  @override
  void onScaleEnd(ScaleEndInfo info) {
    // set the time of start to null again
    _clickStart = null;
    // if this was a selection reset the highlightMatrix by copying another default matrix to it
    if (_clickHeld) {
      UnimplementedError();
    }
    _clickHeld = false;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      // if this is pinch? No idea what this means
      camera.zoom = startZoom * currentScale.x;
      clampZoom();
    } else {
      if (_clickHeld) {
        // // user is holding and dragging
        // final screenPosition = info.eventPosition.game;
        // final block = envLayers[iModel.PuzzleLayer].getBlock(screenPosition);
        // final Block startBlock = envLayers[iModel.PuzzleLayer].getBlock(startPosition);
        // if (envLayers[iModel.PuzzleLayer].containsBlock(block) &&
        //     startBlock.toVector2().distanceTo(block.toVector2()) <= 1) {
        //   // is inside grid bounds
        //   _gameState.highlight(Vector2Int.fromBlock(block: startBlock), Vector2Int.fromBlock(block: block));
        // } else {
        //   // shake the camera till user comes inside the bounds ...
        //   // clear confession I forgot this would shake continuously till the user came in bounds but hey! that works.
        //   camera.shake(duration: 0.02, intensity: 10);
        // }
      } else {
        camera.translateBy(startPosition - info.eventPosition.game);
        camera.snap();
      }
    }
  }
}
