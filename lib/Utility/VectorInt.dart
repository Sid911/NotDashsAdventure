import 'dart:math';

import 'package:flame/components.dart';
import 'package:not_dashs_adventure/Utility/puzzle.dart';

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

  Vector2Int offset(int x, int y) {
    return Vector2Int(x: this.x + x, y: this.y + y);
  }

  double distance(Vector2Int b) {
    return sqrt(pow(x - b.x, 2) + pow(y - b.y, 2).abs());
  }

  Point toPoint() {
    return Point(x, y);
  }
}
