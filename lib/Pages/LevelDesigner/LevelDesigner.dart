import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

class LevelDesigner extends FlameGame with TapDetector, ScrollDetector, ScaleDetector {
  late TextPaint textPaint;
  static const designerUIText = 'options';

  final topLeft = Vector2(0, 0);

  static const srcTileSize = 111.0;
  static const destTileSize = srcTileSize;

  static const halfSize = false;
  static const tileHeight = 128.0;

  final originColor = Paint()..color = const Color(0xFFFF00FF);
  final originColor2 = Paint()..color = const Color(0xFFAA55FF);

  late IsometricTileMapComponent base;

  late Vector2 startPosition;
  late List<List<int>> matrix;
  late SpriteSheet tileset;
  @override
  Future<void> onLoad() async {
    camera.setRelativeOffset(Anchor.center);
    camera.speed = 100;

    await super.onLoad();
    // add overlay UI
    overlays.add(designerUIText);
    overlays.add("blocksList");
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
    matrix = [
      [1, 2, 3, 4, 5],
      [6, 7, 8, 9, 10],
      [11, 12, 13, 14, 15],
      [16, 17, 18, 19, 20],
      [21, 22, 23, 24, 25]
    ];
    base = IsometricTileMapComponent(
      tileset,
      matrix,
      destTileSize: Vector2.all(destTileSize),
      tileHeight: tileHeight,
      position: topLeft,
      anchor: Anchor.center,
    );
  }

  @override
  void render(Canvas canvas) {
    add(base);
    super.render(canvas);
  }

  // @override
  // void onMouseMove(PointerHoverInfo info) {
  //   final screenPosition = info.eventPosition.game;
  //   final block = base.getBlock(screenPosition);
  // }

  @override
  void onTapUp(TapUpInfo info) {
    final screenPosition = info.eventPosition.game;
    final block = base.getBlock(screenPosition);
    print(matrix[block.y][block.x]);
    print('x : ${block.x} , y : ${block.y}');
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
    startPosition = info.eventPosition.game;
    startZoom = camera.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      camera.zoom = startZoom * currentScale.x;
      clampZoom();
    } else {
      camera.translateBy(startPosition - info.eventPosition.game);
      camera.snap();
    }
  }
}
