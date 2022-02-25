import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesignerGameState.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';
import 'package:not_dashs_adventure/Utility/VectorInt.dart';

class LevelDesigner extends FlameBlocGame with TapDetector, ScrollDetector, ScaleDetector, FPSCounter {
  static final fpsTextPaint = TextPaint(
    style: const TextStyle(color: Color(0xFFFF0000)),
  );
  final topLeft = Vector2(0, 0);

  static const srcTileSize = 111.0;
  static const destTileSize = srcTileSize;

  static const halfSize = false;
  static const tileHeight = 128.0;

  final DesignerGameState _gameState = DesignerGameState();
  final TilesheetRepository _tilesheetRepository = TilesheetRepository();
  DateTime? _clickStart;
  bool _clickHeld = false;

  List<IsometricTileMapComponent> envLayers = List<IsometricTileMapComponent>.empty(growable: true);
  late IsometricTileMapComponent _highlight;
  late IsometricTileMapComponent _grid;

  late Vector2 startPosition;
  late SpriteSheet tileset;
  @override
  bool debugMode = true;

  @override
  Future<void> onLoad() async {
    camera.setRelativeOffset(Anchor.center);
    camera.speed = 100;
    await super.onLoad();
    // Load the basic Tileset
    print("starting load");
    final loadedTileset = await _tilesheetRepository.getTileSheet();
    assert(loadedTileset != null);
    print("Tileset loaded");
    tileset = loadedTileset!;
    // Add TileMaps
    computeEnvironment(0);
    _highlight = IsometricTileMapComponent(
      tileset,
      _gameState.highLightMatrix,
      destTileSize: Vector2.all(destTileSize),
      tileHeight: tileHeight,
      position: topLeft,
      anchor: Anchor.center,
    );
    _grid = IsometricTileMapComponent(
      tileset,
      _gameState.gridMatrix,
      destTileSize: Vector2.all(destTileSize),
      tileHeight: tileHeight,
      position: topLeft,
      anchor: Anchor.center,
    );
  }

  void computeEnvironment(int initial) {
    for (int i = initial; i < _gameState.baseMatrix.length; i++) {
      envLayers.add(IsometricTileMapComponent(
        tileset,
        _gameState.baseMatrix[i],
        destTileSize: Vector2.all(destTileSize),
        tileHeight: tileHeight,
        position: topLeft,
        anchor: Anchor.center,
      ));
    }
    print("environment length : ${envLayers.length}");
  }

  @override
  void render(Canvas canvas) {
    add(_grid);
    for (int i = 0; i < envLayers.length; i++) {
      add(envLayers[i]);
    }
    add(_highlight);
    if (debugMode) {
      final double currentfps = fps(100);
      if (currentfps < 20) fpsTextPaint.render(canvas, currentfps.roundToDouble().toString(), Vector2(0, 120));
      // print(fps(100).toString());
    }
    super.render(canvas);
  }

  @override
  void onTapUp(TapUpInfo info) {
    final screenPosition = info.eventPosition.game;
    // get the current state of the UI cubit
    final LevelGenUiState currentUIState = read<LevelGenUiCubit>().state;
    // replace the tile on the base matrix
    if (currentUIState is LevelGenUILoaded) {
      final int totalLayersBefore = _gameState.baseMatrix.length;
      bool hasEnvChanged = _gameState.checkForLayer(currentUIState.currentLayer);
      if (hasEnvChanged) {
        computeEnvironment(totalLayersBefore);
      }

      final block = envLayers[currentUIState.currentLayer].getBlock(screenPosition);
      _gameState.toggleIndex(
          Vector2Int(x: block.x, y: block.y), currentUIState.lastTileIndex, currentUIState.currentLayer);
      print('x : ${block.x} , y : ${block.y}');
    }
    _clickStart = null;
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
    if (_clickStart != null && currentTime.difference(_clickStart!).inMilliseconds > 600) {
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
      // for some reason reassigning highlightMatrix to a copy of a empty list doesn't update... so reassign it manually
      // get the state
      final LevelGenUiState currentUIState = read<LevelGenUiCubit>().state;
      if (currentUIState is LevelGenUILoaded) {
        final int totalLayersBefore = _gameState.baseMatrix.length;
        bool hasEnvChanged = _gameState.checkForLayer(currentUIState.currentLayer);
        if (hasEnvChanged) {
          computeEnvironment(totalLayersBefore);
        }
        _gameState.toggleIndexRangeForLastHighlight(
            replaceIndex: currentUIState.lastTileIndex, layerIndex: currentUIState.currentLayer);
      }
      _gameState.resetHighlight();
      _highlight.matrix = _gameState.highLightMatrix;
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
        // user is holding and dragging
        final screenPosition = info.eventPosition.game;
        final block = _highlight.getBlock(screenPosition);
        if (block.x >= 0 && block.x <= _gameState.size && block.y >= 0 && block.y <= _gameState.size) {
          // is inside grid bounds
          final Block startBlock = _highlight.getBlock(startPosition);
          _gameState.highlight(Vector2Int.fromBlock(block: startBlock), Vector2Int.fromBlock(block: block));
        } else {
          // shake the camera till user comes inside the bounds ...
          // clear confession I forgot this would shake continuously till the user came in bounds but hey! that works.
          camera.shake(duration: 0.02, intensity: 10);
        }
      } else {
        camera.translateBy(startPosition - info.eventPosition.game);
        camera.snap();
      }
    }
  }
}
