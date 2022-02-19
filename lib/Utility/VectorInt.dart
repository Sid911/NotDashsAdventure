import 'dart:math';

import 'package:flame/components.dart';

class Vector2Int {
  Vector2Int({required this.x, required this.y});
  Vector2Int.fromBlock({required Block block})
      : x = block.x,
        y = block.y;
  int x, y;
  void clampNegativeToZero() {
    x = x < 0 ? 0 : x;
    y = y < 0 ? 0 : y;
  }

  double distance(Vector2Int b) {
    return sqrt((x * x - b.x * b.x).abs() + (y * y - b.y * b.y).abs());
  }
}
