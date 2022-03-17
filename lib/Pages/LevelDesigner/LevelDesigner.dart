import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Levels/JsonLevelModel.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesignerGameState.dart';
import 'package:not_dashs_adventure/Utility/Repositories/TilesheetRepository.dart';
import 'package:not_dashs_adventure/Utility/VectorInt.dart';

import '../Components/IsometricTileMapCustom.dart';

class LevelDesigner extends FlameBlocGame with TapDetector, ScrollDetector, ScaleDetector, FPSCounter {
  LevelDesigner({this.iModel});
  // Level Mode
  LevelModel? iModel;
  // Paints
  static final fpsTextPaint = TextPaint(
    style: const TextStyle(color: Color(0xFFFF0000)),
  );
  final backgroundPaint = Paint();
  late Rect rect;
  final topLeft = Vector2(0, 0);

  static double srcTileSize = 225.0;
  // static double destTileSize = srcTileSize;

  static const halfSize = false;
  static double tileHeight = 257.0;

  late DesignerGameState _gameState;
  final TilesheetRepository _tilesheetRepository = TilesheetRepository();
  DateTime? _clickStart;

  bool _clickHeld = false;
  bool reRenderBackground = true;

  List<IsometricTileMapCustom> envLayers = List<IsometricTileMapCustom>.empty(growable: true);
  late IsometricTileMapCustom _highlight;
  late IsometricTileMapCustom _grid;

  late Vector2 startPosition;
  late SpriteSheet tileset;

  @override
  bool debugMode = true;

  @override
  Future<void> onLoad() async {
    camera.setRelativeOffset(Anchor.center);
    camera.speed = 100;
    if (iModel != null) {
      camera.zoom = iModel!.Zoom;
      // camera.snapTo(Vector2(iModel!.CameraPosition[0], iModel!.CameraPosition[0]));
    }
    await super.onLoad();
    // Load the basic Tileset and set the state

    final loadedTileset = iModel != null
        ? await _tilesheetRepository.getTileSheet(tilesheetName: iModel!.TilesetUID)
        : await _tilesheetRepository.getTileSheet();

    assert(loadedTileset != null);
    _gameState = DesignerGameState(
      gridSpriteIndex: _tilesheetRepository.currentTilesheetLog!.gridIndex,
      highlightSpriteIndex: _tilesheetRepository.currentTilesheetLog!.highlightIndex,
    );
    if (iModel != null) {
      _gameState.levelName = iModel!.LevelName;
      _gameState.baseMatrix = iModel!.Layers;
    }
    tileset = loadedTileset!;
    // get the src dimension
    srcTileSize = _tilesheetRepository.currentTilesheetLog!.srcSize[0].toDouble();
    tileHeight = _tilesheetRepository.currentTilesheetLog!.srcSize[1].toDouble();

    // Add TileMaps
    computeEnvironment(0);
    _highlight = IsometricTileMapCustom(
      tileset,
      _gameState.highLightMatrix,
      scalingFactor: 1.1538461538461538461538461538462,
      tileHeight: srcTileSize,
      position: topLeft,
      anchor: Anchor.topLeft,
      priority: 100,
    );
    _grid = IsometricTileMapCustom(
      tileset,
      _gameState.gridMatrix,
      scalingFactor: 1.1538461538461538461538461538462,
      tileHeight: srcTileSize,
      position: topLeft,
      anchor: Anchor.topLeft,
    );
  }

  @override
  void onAttach() {
    super.onAttach();
    // get height and width and assign paint
    final mUICubit = read<LevelGenUiCubit>();
    LevelGenUiState mUIState = mUICubit.state;
    if (iModel != null) {
      mUICubit.setLayerIndex(iModel!.PuzzleLayer);
      mUICubit.setBackgroundGradientBeginColor(Color(int.parse(iModel!.hexGradientStart, radix: 16)));
      mUICubit.setBackgroundGradientEndColor(Color(int.parse(iModel!.hexGradientEnd, radix: 16)));
      mUIState = mUICubit.state;
    }
    assignBackground(startingColor: mUIState.backgroundBeginColor, endingColor: mUIState.backgroundEndColor);
  }

  void computeEnvironment(int initial) {
    for (int i = initial; i < _gameState.baseMatrix.length; i++) {
      final newPosition = Vector2(0, -1 * i * tileHeight / 2);
      envLayers.add(IsometricTileMapCustom(
        tileset,
        _gameState.baseMatrix[i],
        priority: i,
        angle: 0,
        tileHeight: tileHeight,
        scalingFactor: tileHeight / srcTileSize,
        position: newPosition,
        anchor: Anchor.topLeft,
        puzzleSize: Vector2(_tilesheetRepository.currentTilesheetLog!.puzzlePieceSize[0].toDouble(),
            _tilesheetRepository.currentTilesheetLog!.puzzlePieceSize[1].toDouble()),
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

  void moveGridForLayer(bool up) {
    print("moving Grid : $up");
    up ? _grid.position.sub(Vector2(0, tileHeight / 2)) : _grid.position.add(Vector2(0, tileHeight / 2));
    up ? _highlight.position.sub(Vector2(0, tileHeight / 2)) : _highlight.position.add(Vector2(0, tileHeight / 2));
  }

  void saveLevel({required bool includeTileSet, required bool export, required String name}) {
    currentUICubit = read<LevelGenUiCubit>();
    _gameState.levelName = name;
    _gameState.save(
      tilesetUID: _tilesheetRepository.currentTilesheetKey,
      cameraZoom: camera.zoom,
      cameraPosition: camera.position,
      tilesetIncluded: includeTileSet,
      puzzleLayer: currentUICubit.state.puzzleLayer,
      gradientBegin: currentUICubit.state.backgroundBeginColor,
      gradientEnd: currentUICubit.state.backgroundEndColor,
    );
  }

  @override
  void render(Canvas canvas) {
    if (reRenderBackground) {
      print("rendering Background");
      final state = read<LevelGenUiCubit>().state;
      assignBackground(startingColor: state.backgroundBeginColor, endingColor: state.backgroundEndColor);
      reRenderBackground = false;
    }
    canvas.drawRect(rect, backgroundPaint);

    for (int i = 0; i < envLayers.length; i++) {
      add(envLayers[i]);
    }
    add(_grid);
    add(_highlight);
    if (debugMode) {
      final double currentfps = fps(100);
      if (currentfps < 20) fpsTextPaint.render(canvas, currentfps.roundToDouble().toString(), Vector2(0, 200));
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
  late LevelGenUiCubit currentUICubit;
  @override
  void onScaleStart(ScaleStartInfo info) {
    // get the position and zoom the scale started from
    startPosition = info.eventPosition.game;
    startZoom = camera.zoom;
    currentUICubit = read<LevelGenUiCubit>();
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
        final block = envLayers[currentUICubit.state.currentLayer].getBlock(screenPosition);
        if (block.x >= 0 && block.x <= _gameState.size && block.y >= 0 && block.y <= _gameState.size) {
          // is inside grid bounds
          final Block startBlock = envLayers[currentUICubit.state.currentLayer].getBlock(startPosition);
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
