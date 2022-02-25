part of 'level_gen_ui_cubit.dart';

abstract class LevelGenUiState extends Equatable {
  const LevelGenUiState({required this.showUI, this.tileset, this.totalTiles, this.currentLayer = 0});
  final bool showUI;
  final int currentLayer;
  final SpriteSheet? tileset;
  final int? totalTiles;
}

class LevelGenUILoaded extends LevelGenUiState {
  const LevelGenUILoaded({
    required SpriteSheet tilesheet,
    required int totalTiles,
    required int currentLayer,
    required this.lastTileIndex,
  }) : super(showUI: true, tileset: tilesheet, totalTiles: totalTiles, currentLayer: currentLayer);
  final int lastTileIndex;
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, lastTileIndex, currentLayer];
}

class LevelGenUILoading extends LevelGenUiState {
  const LevelGenUILoading({required int currentLayer})
      : super(
          showUI: false,
          currentLayer: currentLayer,
        );
  final bool loading = true;
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, loading];
}

class LevelGenUIHide extends LevelGenUiState {
  const LevelGenUIHide({required int currentLayer}) : super(showUI: false, currentLayer: currentLayer);
  @override
  List<Object?> get props => [showUI, tileset, totalTiles];
}
