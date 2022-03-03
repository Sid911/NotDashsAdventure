part of 'level_gen_ui_cubit.dart';

abstract class LevelGenUiState extends Equatable {
  const LevelGenUiState(
      {required this.showUI, this.tileset, this.totalTiles, required this.darkMode, this.currentLayer = 0});
  final bool showUI;
  final bool darkMode;
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
    required bool darkMode,
  }) : super(showUI: true, tileset: tilesheet, totalTiles: totalTiles, currentLayer: currentLayer, darkMode: darkMode);
  final int lastTileIndex;
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, lastTileIndex, currentLayer, darkMode];
}

class LevelGenUILoading extends LevelGenUiState {
  const LevelGenUILoading({required int currentLayer, required bool darkMode})
      : super(showUI: false, currentLayer: currentLayer, darkMode: darkMode);
  final bool loading = true;
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, loading, darkMode];
}

class LevelGenUIHide extends LevelGenUiState {
  const LevelGenUIHide({required int currentLayer, required bool darkMode})
      : super(showUI: false, currentLayer: currentLayer, darkMode: darkMode);
  @override
  List<Object?> get props => [showUI, tileset, totalTiles, darkMode];
}
