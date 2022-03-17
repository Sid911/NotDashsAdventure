import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'package:not_dashs_adventure/Utility/puzzle.dart';

/// This component renders a tilemap, represented by an int matrix, given a
/// tileset, in which the integers are the block ids.
///
/// It can change the scale of each block by using the optional destTileSize
/// property.
class IsometricTileMapCustom extends PositionComponent {
  /// This is the tileset that will be used to render this map.
  SpriteSheet tileset;

  /// The positions of each block will be placed respecting this matrix.
  List<List<int>> matrix;

  /// Optionally provide a new tile size to render it scaled.
  Vector2? destTileSize;

  /// This is the vertical height of each block in the tile set.
  ///
  /// Note: this must be measured in the destination space.
  double? tileHeight;

  double scalingFactor;

  Vector2? puzzleSize;
  // Render lines
  bool renderLines = false;
  List<Point> points = List.empty();
  final linePaint = Paint()..color = const Color(0xFF000000);

  IsometricTileMapCustom(
    this.tileset,
    this.matrix, {
    this.destTileSize,
    this.tileHeight,
    this.scalingFactor = 1,
    this.puzzleSize,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        );

  /// This is the size the tiles will be drawn (either original or overwritten).
  Vector2 get effectiveTileSize => destTileSize ?? tileset.srcSize;

  /// This is the vertical height of each block; by default it's half the tile size.
  double get effectiveTileHeight => tileHeight ?? (effectiveTileSize.y / 2);

  Vector2 get pSize => puzzleSize ?? tileset.srcSize;
  @override
  void render(Canvas c) {
    final size = effectiveTileSize;
    for (var i = 0; i < matrix.length; i++) {
      for (var j = 0; j < matrix[i].length; j++) {
        final element = matrix[i][j];
        if (element != -1) {
          final sprite = element < -1
              ? Sprite(
                  tileset.image,
                  srcPosition: Vector2(
                    pSize.x * ((element + 2).abs() % (tileset.image.width / pSize.x).floor()),
                    tileset.image.height -
                        pSize.y * (((element + 2).abs() / (tileset.image.width / pSize.x).floor()).floor() + 1),
                  ),
                  srcSize: pSize,
                )
              : tileset.getSpriteById(element);
          final p = element < -1 ? getBottomLeftPositionInts(j, i) : getBlockRenderPositionInts(j, i);
          sprite.render(c, position: p, size: element < -1 ? pSize : size);
        }
      }
    }
    if (renderLines) {
      for (int i = 0; i < points.length - 1; i++) {
        c.drawLine(getBlockCenterPosition(points[i].toBlock()).toOffset(),
            getBlockCenterPosition(points[i + 1].toBlock()).toOffset(), linePaint);
      }
    }
  }

  /// Get the position in which a block is rendered in, in the isometric space.
  ///
  /// This does not include the (x,y) PositionComponent offset!
  /// This assumes the tile sprite as a rectangular tile.
  /// This is the opposite of [getBlockRenderedAt].
  Vector2 getBlockRenderPosition(Block block) {
    return getBlockRenderPositionInts(block.x, block.y);
  }

  /// Same as getBlockRenderPosition but the arguments are exploded as integers.
  Vector2 getBlockRenderPositionInts(int i, int j) {
    final halfTile = Vector2(effectiveTileSize.x / 2, (effectiveTileSize.y / 2) / scalingFactor);
    final pos = Vector2(i.toDouble(), j.toDouble())..multiply(halfTile);
    return cartToIso(pos) - halfTile;
  }

  Vector2 getBottomLeftPositionInts(int i, int j) {
    Vector2 initialPosition = getBlockRenderPositionInts(i, j);
    initialPosition
        .sub(Vector2(pSize.x - effectiveTileSize.x, pSize.y - effectiveTileSize.y - effectiveTileHeight / 2));
    return initialPosition;
  }

  /// Get the position of the center of the surface of the isometric tile in
  /// the cartesian coordinate space.
  ///
  /// This is the opposite of [getBlock].
  Vector2 getBlockCenterPosition(Block block) {
    final tile = effectiveTileSize;
    return getBlockRenderPosition(block) + Vector2(tile.x / 2, tile.y - effectiveTileHeight / 2);
  }

  /// Converts a coordinate from the isometric space to the cartesian space.
  Vector2 isoToCart(Vector2 p) {
    final x = p.y / scalingFactor + p.x / 2;
    final y = p.y - p.x * scalingFactor / 2;
    return Vector2(x, y);
  }

  /// Converts a coordinate from the cartesian space to the isometric space.
  Vector2 cartToIso(Vector2 p) {
    final x = p.x - p.y;
    final y = ((p.x + p.y) * scalingFactor) / 2;
    return Vector2(x, y);
  }

  /// Get which block's surface is at isometric position [p].
  ///
  /// This can be used to handle clicks or hovers.
  /// This is the opposite of [getBlockCenterPosition].
  Block getBlock(Vector2 p) {
    final halfTile = Vector2(effectiveTileSize.x / 2, effectiveTileSize.y / 2);
    final multiplier = 1 - halfTile.y / (2 * effectiveTileHeight);

    final delta = halfTile.clone()..multiply(Vector2(1, multiplier));
    final cart = isoToCart(p - position + delta);
    final px = (cart.x / halfTile.x - 1).ceil();
    final py = (cart.y / (halfTile.y)).ceil();
    return Block(px, py);
  }

  /// Get which block should be rendered on position [p].
  ///
  /// This is the opposite of [getBlockRenderPosition].
  Block getBlockRenderedAt(Vector2 p) {
    final tile = effectiveTileSize;
    return getBlock(
      p + Vector2(tile.x / 2, tile.y - effectiveTileHeight - tile.y / 4),
    );
  }

  /// Sets the block value into the matrix.
  void setBlockValue(Block pos, int block) {
    matrix[pos.y][pos.x] = block;
  }

  /// Gets the block value from the matrix.
  int blockValue(Block pos) {
    return matrix[pos.y][pos.x];
  }

  /// Return whether the matrix contains a block in its bounds.
  bool containsBlock(Block block) {
    return block.y >= 0 && block.y < matrix.length && block.x >= 0 && block.x < matrix[block.y].length;
  }
}
