import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class LevelDesigner extends FlameGame with MouseMovementDetector, TapDetector, VerticalDragDetector, HorizontalDragDetector {
  late TextPaint textPaint;
  static const designerUIText = 'designer';
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    overlays.add(designerUIText);
    textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 48.0,
        fontFamily: 'Awesome Font',
      ),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
