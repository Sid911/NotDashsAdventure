import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:not_dashs_adventure/Bloc/LevelGen/level_gen_ui_cubit.dart';
import 'package:not_dashs_adventure/Pages/LevelDesigner/LevelDesignerGameState.dart';
import 'package:not_dashs_adventure/Utility/VectorInt.dart';

class LevelDesigner extends FlameBlocGame with TapDetector, ScrollDetector, ScaleDetector {
  late TextPaint textPaint;
  static const designerUIText = 'options';

  final topLeft = Vector2(0, 0);

  static const srcTileSize = 111.0;
  static const destTileSize = srcTileSize;

  static const halfSize = false;
  static const tileHeight = 128.0;
  final DesignerGameState _gameState = DesignerGameState();
  DateTime? _clickStart;
  bool _clickHeld = false;

  late IsometricTileMapComponent base;
  late IsometricTileMapComponent _highlight;
  late IsometricTileMapComponent _grid;

  late Vector2 startPosition;
  late SpriteSheet tileset;

  @override
  Future<void> onLoad() async {
    camera.setRelativeOffset(Anchor.center);
    camera.speed = 100;

    await super.onLoad();
    // add overlay UI
    // overlays.add(designerUIText);
    // overlays.add("blocksList");
    // Text Paint
    textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 48.0,
        fontFamily: 'Awesome Font',
      ),
    );

    final tilesetImage = await images.load('tilesheet.png');
    tileset = SpriteSheet(
      image: tilesetImage,
      srcSize: Vector2(srcTileSize, 128),
    );

    base = IsometricTileMapComponent(
      tileset,
      _gameState.baseMatrix,
      destTileSize: Vector2.all(destTileSize),
      tileHeight: tileHeight,
      position: topLeft,
      anchor: Anchor.center,
    );
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

  @override
  void render(Canvas canvas) {
    add(_grid);
    add(base);
    add(_highlight);
    super.render(canvas);
  }

  @override
  void onTapUp(TapUpInfo info) {
    final screenPosition = info.eventPosition.game;
    // get the current state of the UI cubit
    final LevelGenUiState currentUIState = read<LevelGenUiCubit>().state;
    final block = base.getBlock(screenPosition);
    // replace the tile on the base matrix
    if (currentUIState is LevelGenUILoaded) {
      _gameState.toggleIndex(Vector2Int(x: block.x, y: block.y), currentUIState.lastIndex);
    }
    print('x : ${block.x} , y : ${block.y}');
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
        _gameState.toggleIndexRangeForLastHighlight(replaceIndex: currentUIState.lastIndex);
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
