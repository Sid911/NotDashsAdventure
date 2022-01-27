import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/input.dart';

class LevelDesigner extends FlameGame with MouseMovementDetector, TapDetector, VerticalDragDetector, HorizontalDragDetector {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
