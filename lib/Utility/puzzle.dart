import 'package:flame/components.dart';
import 'package:logging/logging.dart';

import 'direction.dart';

enum PuzzleCell {
  blocked,
  rNE,
  rNW,
  rSE,
  rSW,
  rW,
  rE,
  rN,
  rS,
  reflect,
  open,
  oneWayN,
  oneWayNE,
  oneWayNW,
  oneWayS,
  oneWaySE,
  oneWaySW,
  oneWayW,
  oneWayE,
  sourceN,
  sourceNW,
  end
}

extension PuzzleInt on PuzzleCell {
  int get id {
    switch (this) {
      case PuzzleCell.blocked:
        return 0;
      case PuzzleCell.rNE:
        return -3;
      case PuzzleCell.rNW:
        return -10;
      case PuzzleCell.rSE:
        return -9;
      case PuzzleCell.rSW:
        return -4;
      case PuzzleCell.rW:
        return -8;
      case PuzzleCell.rE:
        return -5;
      case PuzzleCell.rN:
        return -7;
      case PuzzleCell.rS:
        return -6;
      case PuzzleCell.reflect:
        return 1;
      case PuzzleCell.open:
        return -1;
      case PuzzleCell.oneWayN:
        return -11;
      case PuzzleCell.oneWayNE:
        return -18;
      case PuzzleCell.oneWayNW:
        return -15;
      case PuzzleCell.oneWayS:
        return -14;
      case PuzzleCell.oneWaySE:
        return -16;
      case PuzzleCell.oneWaySW:
        return -17;
      case PuzzleCell.oneWayW:
        return -11;
      case PuzzleCell.oneWayE:
        return -13;
      case PuzzleCell.sourceN:
        return -20;
      case PuzzleCell.sourceNW:
        return -21;
      case PuzzleCell.end:
        return -19;
    }
  }
}

PuzzleCell getPuzzleFromID(int id) {
  if (id > -1) return PuzzleCell.blocked;
  if (id == -2) return PuzzleCell.open;
  for (final x in PuzzleCell.values) {
    if (x.id == id) {
      return x;
    }
  }
  // unexpected happened
  print(id);
  assert(false);
  return PuzzleCell.blocked;
}

class Point {
  int x;
  int y;
  PuzzleCell? cell;
  Point(this.x, this.y, {this.cell});

  Point operator +(Point other) {
    return Point(x + other.x, y + other.y, cell: cell);
  }

  Block toBlock() {
    return Block(x, y);
  }

  @override
  String toString() {
    return "( $x, $y )";
  }

  @override
  bool operator ==(Object other) {
    assert(other is Point);
    final obj = other as Point;
    if (x == obj.x && y == obj.y) return true;
    return false;
  }
}

class Puzzle {
  /// Constructor for the puzzle
  Puzzle({
    required List<List<PuzzleCell>> data,
    required this.maxSolDistance,
    required this.start,
    required this.end,
    this.startDirection = MotionDirection.N,
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

  final Logger _logger = Logger("Puzzle");

  /// swaps two Cells from their coordinates
  bool swapCells(Point cell1, Point cell2) {
    if ((cell1.x - cell2.x).abs() != 1 && (cell2.x - cell2.x).abs() != 1) {
      _logger.log(Level.FINE, "Difference between swap cells is too much");
      return false;
    }
    if (areInBounds(cell1.x, cell1.y) && areInBounds(cell2.x, cell2.y)) {
      if (cellCanBeMoved(cell1) && cellCanBeMoved(cell2)) {
        PuzzleCell tempCell = puzzleMatrix[cell1.y][cell1.x];
        puzzleMatrix[cell1.y][cell1.x] = puzzleMatrix[cell2.y][cell2.x];
        puzzleMatrix[cell2.y][cell2.x] = tempCell;
        return true;
      } else {
        _logger.log(Level.WARNING, "The cell/s cannot be moved");
        return false;
      }
    } else {
      _logger.log(Level.WARNING, "The cell/s were out of bounds");
      return false;
    }
  }

  bool cellCanBeMoved(Point cell) {
    final PuzzleCell element = puzzleMatrix[cell.y][cell.x];
    if (element != PuzzleCell.blocked &&
        element != PuzzleCell.sourceN &&
        element != PuzzleCell.sourceNW &&
        element != PuzzleCell.end) {
      return true;
    }
    return false;
  }

  int _steps = 0;

  /// Checks the path of the light in order to get results
  List<Point> getCurrentLightPath() {
    List<Point> pathRecord = List<Point>.empty(growable: true);
    List<MotionDirection> directionRecord = List<MotionDirection>.empty(growable: true);
    MotionDirection currentMotionDir = startDirection;
    Point currentPoint = start;

    // add starting points
    pathRecord.add(currentPoint);
    directionRecord.add(currentMotionDir);
    while (_steps < maxSolDistance) {
      Point nextPoint = _traverseTillFound(currentPoint, currentMotionDir);
      print("next point : ${nextPoint.x} , ${nextPoint.y} ; ${nextPoint.cell.toString()}");
      MotionDirection nextDir = findNewDirection(currentMotionDir, nextPoint.cell!);
      print("next Direction : ${nextDir.toString()}");
      pathRecord.add(nextPoint);
      directionRecord.add(nextDir);
      if (nextDir == MotionDirection.none) {
        break;
      }
      currentPoint = nextPoint;
      currentMotionDir = nextDir;
    }
    return pathRecord;
  }

  Point _traverseTillFound(Point start, MotionDirection direction) {
    Point offset;
    Point current = start;
    switch (direction) {
      case MotionDirection.N:
        offset = Point(0, -1);
        break;
      case MotionDirection.S:
        offset = Point(0, 1);
        break;
      case MotionDirection.W:
        offset = Point(-1, 0);
        break;
      case MotionDirection.E:
        offset = Point(1, 0);
        break;
      case MotionDirection.NW:
        offset = Point(-1, -1);
        break;
      case MotionDirection.NE:
        offset = Point(1, -1);
        break;
      case MotionDirection.SW:
        offset = Point(-1, 1);
        break;
      case MotionDirection.SE:
        offset = Point(1, 1);
        break;
      default:
        return Point(start.x, start.y, cell: PuzzleCell.blocked);
    }

    while (true) {
      _steps++;
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
    case PuzzleCell.rNE:
      if (lastDir == MotionDirection.W) {
        return MotionDirection.N;
      } else if (lastDir == MotionDirection.S) {
        return MotionDirection.E;
      }
      return MotionDirection.none;
    case PuzzleCell.rNW:
      if (lastDir == MotionDirection.E) {
        return MotionDirection.N;
      } else if (lastDir == MotionDirection.S) {
        return MotionDirection.W;
      }
      return MotionDirection.none;
    case PuzzleCell.rSE:
      if (lastDir == MotionDirection.W) {
        return MotionDirection.S;
      } else if (lastDir == MotionDirection.N) {
        return MotionDirection.E;
      }
      return MotionDirection.none;
    case PuzzleCell.rSW:
      if (lastDir == MotionDirection.E) {
        return MotionDirection.S;
      } else if (lastDir == MotionDirection.N) {
        return MotionDirection.W;
      }
      return MotionDirection.none;
    case PuzzleCell.rN:
      if (lastDir == MotionDirection.SE) {
        return MotionDirection.NE;
      } else if (lastDir == MotionDirection.SW) {
        return MotionDirection.NW;
      }
      return MotionDirection.none;
    case PuzzleCell.rS:
      if (lastDir == MotionDirection.NE) {
        return MotionDirection.SE;
      } else if (lastDir == MotionDirection.NW) {
        return MotionDirection.SW;
      }
      return MotionDirection.none;
    case PuzzleCell.rE:
      if (lastDir == MotionDirection.NW) {
        return MotionDirection.NE;
      } else if (lastDir == MotionDirection.SW) {
        return MotionDirection.SE;
      }
      return MotionDirection.none;
    case PuzzleCell.rW:
      if (lastDir == MotionDirection.NE) {
        return MotionDirection.SW;
      } else if (lastDir == MotionDirection.SE) {
        return MotionDirection.NW;
      }
      return MotionDirection.none;
    case PuzzleCell.reflect:
      switch (lastDir) {
        case MotionDirection.N:
          return MotionDirection.S;
        case MotionDirection.S:
          return MotionDirection.E;
        case MotionDirection.W:
          return MotionDirection.E;
        case MotionDirection.E:
          return MotionDirection.W;
        case MotionDirection.NW:
          return MotionDirection.SE;
        case MotionDirection.NE:
          return MotionDirection.SW;
        case MotionDirection.SW:
          return MotionDirection.NE;
        case MotionDirection.SE:
          return MotionDirection.NW;
        case MotionDirection.none:
          return MotionDirection.none;
      }
    case PuzzleCell.open:
      return lastDir;
    case PuzzleCell.oneWayN:
      return lastDir == MotionDirection.N ? MotionDirection.N : MotionDirection.none;
    case PuzzleCell.oneWayS:
      return lastDir == MotionDirection.S ? MotionDirection.S : MotionDirection.none;
    case PuzzleCell.oneWayW:
      return lastDir == MotionDirection.W ? MotionDirection.W : MotionDirection.none;
    case PuzzleCell.oneWayE:
      return lastDir == MotionDirection.E ? MotionDirection.E : MotionDirection.none;
    case PuzzleCell.oneWayNE:
      return lastDir == MotionDirection.NE ? MotionDirection.NE : MotionDirection.none;
    case PuzzleCell.oneWayNW:
      return lastDir == MotionDirection.NW ? MotionDirection.NW : MotionDirection.none;
    case PuzzleCell.oneWaySE:
      return lastDir == MotionDirection.SE ? MotionDirection.NE : MotionDirection.none;
    case PuzzleCell.oneWaySW:
      return lastDir == MotionDirection.SW ? MotionDirection.SW : MotionDirection.none;
    default:
      return MotionDirection.none;
  }
}
