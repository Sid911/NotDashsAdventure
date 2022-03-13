import 'package:logging/logging.dart';

import 'direction.dart';

enum PuzzleCell {
  blocked,
  blockedGround,
  rTopRight,
  rTopLeft,
  rBottomRight,
  rBottomLeft,
  rLeft,
  rRight,
  rTop,
  rBottom,
  reflect,
  open,
  oneWayUp,
  oneWayDown,
  oneWayLeft,
  oneWayRight,
}

class Point {
  int x;
  int y;
  PuzzleCell? cell;
  Point(this.x, this.y, {this.cell});

  Point operator +(Point other) {
    return Point(x + other.x, y + other.y, cell: cell);
  }
}

class Puzzle {
  /// Constructor for the puzzle
  Puzzle({
    required List<List<PuzzleCell>> data,
    required this.maxSolDistance,
    required this.start,
    required this.end,
    this.startDirection = MotionDirection.up,
    this.endDirection = MotionDirection.up,
  }) : puzzleMatrix = data {
    dimension = Point(data.first.length, data.length);
  }
  late Point dimension;

  /// Matrix of the puzzle Itself
  List<List<PuzzleCell>> puzzleMatrix;

  /// Max Distance travelled by the light ray when in order to complete the level
  int maxSolDistance;

  /// Starting Index and Ending Index
  Point start;
  Point end;

  /// Direction from the ray will start or exit towards the start
  ///
  /// This is used to determine the exit boundary as well and leaving the space for the start and end thingies
  MotionDirection startDirection;
  MotionDirection endDirection;

  final Logger _logger = Logger("Puzzle");

  /// swaps two Cells from their coordinates
  bool swapCells(Point cell1, Point cell2) {
    if ((cell1.x - cell2.x).abs() != 1 && (cell2.x - cell2.x).abs() != 1) {
      _logger.log(Level.FINE, "Difference between swap cells is too much");
      return false;
    }
    if (areInBounds(cell1.x, cell1.y) && areInBounds(cell2.x, cell2.y)) {
      PuzzleCell tempCell = puzzleMatrix[cell1.y][cell1.x];
      puzzleMatrix[cell1.y][cell1.x] = puzzleMatrix[cell2.y][cell2.x];
      puzzleMatrix[cell2.y][cell2.x] = tempCell;
      return true;
    } else {
      _logger.log(Level.WARNING, "The cell/s were out of bounds");
      return false;
    }
  }

  /// Checks the path of the light in order to get results
  List<Point> getCurrentLightPath() {
    List<Point> pathRecord = List<Point>.empty(growable: true);
    List<MotionDirection> directionRecord = List<MotionDirection>.empty(growable: true);
    MotionDirection currentMotionDir = startDirection;
    Point currentPoint = start;

    // add starting points
    pathRecord.add(currentPoint);
    directionRecord.add(currentMotionDir);

    while (true) {
      Point nextPoint = _traverseTillFound(currentPoint, currentMotionDir);
      print("next point : ${nextPoint.x} , ${nextPoint.y} ; ${nextPoint.cell.toString()}");
      MotionDirection nextDir = findNewDirection(currentMotionDir, nextPoint.cell!);
      print("next Direction : ${nextDir.toString()}");
      if (nextDir == MotionDirection.none) {
        break;
      }
      pathRecord.add(nextPoint);
      directionRecord.add(nextDir);
      currentPoint = nextPoint;
      currentMotionDir = nextDir;
    }
    return pathRecord;
  }

  Point _traverseTillFound(Point start, MotionDirection direction) {
    Point offset;
    Point current = start;
    switch (direction) {
      case MotionDirection.up:
        offset = Point(0, -1);
        break;
      case MotionDirection.down:
        offset = Point(0, 1);
        break;
      case MotionDirection.left:
        offset = Point(-1, 0);
        break;
      case MotionDirection.right:
        offset = Point(1, 0);
        break;
      case MotionDirection.topLeft:
        offset = Point(-1, -1);
        break;
      case MotionDirection.topRight:
        offset = Point(1, -1);
        break;
      case MotionDirection.bottomLeft:
        offset = Point(-1, 1);
        break;
      case MotionDirection.bottomRight:
        offset = Point(1, 1);
        break;
      default:
        return Point(start.x, start.y, cell: PuzzleCell.blocked);
    }

    while (true) {
      current = current + offset;
      if (areInBounds(current.x, current.y)) {
        PuzzleCell cell = puzzleMatrix[current.y][current.x];
        if (cell != PuzzleCell.open) {
          return Point(current.x, current.y, cell: cell);
        }
      } else {
        _logger.log(Level.WARNING, "The cell/s were out of bounds while traversing");
        return Point(current.x, current.y, cell: PuzzleCell.blocked);
      }
    }
  }

  bool areInBounds(int x, int y) {
    return x >= 0 && x < dimension.x && y >= 0 && y < dimension.y;
  }
}

MotionDirection findNewDirection(MotionDirection lastDir, PuzzleCell blockType) {
  // Arghhhhh I really don't want to think about a concise way of doing this probably would be easier to represent them as numbers
  // but I am typing because I am tired.
  switch (blockType) {
    case PuzzleCell.rTopRight:
      if (lastDir == MotionDirection.right) {
        return MotionDirection.down;
      } else if (lastDir == MotionDirection.up) {
        return MotionDirection.left;
      }
      return MotionDirection.none;
    case PuzzleCell.rTopLeft:
      if (lastDir == MotionDirection.left) {
        return MotionDirection.down;
      } else if (lastDir == MotionDirection.up) {
        return MotionDirection.right;
      }
      return MotionDirection.none;
    case PuzzleCell.rBottomRight:
      if (lastDir == MotionDirection.right) {
        return MotionDirection.up;
      } else if (lastDir == MotionDirection.down) {
        return MotionDirection.left;
      }
      return MotionDirection.none;
    case PuzzleCell.rBottomLeft:
      if (lastDir == MotionDirection.left) {
        return MotionDirection.up;
      } else if (lastDir == MotionDirection.down) {
        return MotionDirection.right;
      }
      return MotionDirection.none;
    case PuzzleCell.reflect:
      if (lastDir == MotionDirection.up) {
        return MotionDirection.down;
      } else if (lastDir == MotionDirection.down) {
        return MotionDirection.up;
      } else if (lastDir == MotionDirection.right) {
        return MotionDirection.left;
      } else if (lastDir == MotionDirection.left) {
        return MotionDirection.right;
      }
      return MotionDirection.none;
    case PuzzleCell.open:
      return lastDir;
    case PuzzleCell.oneWayUp:
      return lastDir == MotionDirection.up ? MotionDirection.up : MotionDirection.none;
    case PuzzleCell.oneWayDown:
      return lastDir == MotionDirection.down ? MotionDirection.down : MotionDirection.none;
    case PuzzleCell.oneWayLeft:
      return lastDir == MotionDirection.left ? MotionDirection.left : MotionDirection.none;
    case PuzzleCell.oneWayRight:
      return lastDir == MotionDirection.right ? MotionDirection.right : MotionDirection.none;
    default:
      return MotionDirection.none;
  }
}
